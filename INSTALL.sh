#!/bin/bash
gpu="gfx1100"
yad --center --borders=20 --title="Select your Python Version"  --text="Wich Python Version will you want to use?" --button="Python 3.10.17":"0" --button="Python 3.13.2":"1"
pyver=$?
tars=("py310.tar.xz" "py313.tar.xz")
pydir=("py310" "py313")
tar xvf pyvers/${tars[$pyver]}
export PATH="$PWD/${pydir[$pyver]}/bin:$PATH"
pip3 install --upgrade pip
python3 -m pip install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.4
python3 -m pip install -r requirements.txt
export FLASH_ATTENTION_TRITON_AMD_ENABLE="TRUE"
export GPU_ARCHS=$gpu
git clone --single-branch --branch main_perf https://github.com/ROCm/flash-attention.git
cd flash-attention/
python3 -m pip install sentencepiece packaging
python3 setup.py install
cd ..
git clone https://github.com/Tencent-Hunyuan/Hunyuan3D-2.git
cd Hunyuan3D-2
python3 -m pip install -e .
cd hy3dgen/texgen/differentiable_renderer/
python3 setup.py install
cd ../../../
python3 -m pip install ../wheels/custom_rasterizer-0.1-${pydir[$pyver]}-none-manylinux_2_39_x86_64.whl
python3 -m pip install gradio==5.33.0 opencv-python==4.9.0.80 opencv-python-headless==4.10.0.84 numpy==1.26.4
if [[ $pyver -eq 0 ]]
then
python3 -m pip install jmespath 
fi
cd ..
 yad --center --width=200  --title="Select a port for Gradio App"  --text="Wich Port will you want to use?" --text-info --editable < port > port2
rm port
mv port2 port
echo -e \#\!"/bin/bash\nexport PATH=\"$PWD/${pydir[$pyver]}/bin:\$PATH\"\nexport FLASH_ATTENTION_TRITON_AMD_ENABLE=\"TRUE\"\nexport GPU_ARCHS=\"gfx1100\"\nport=\`cat ../port\`\npython3 gradio_app.py --model_path tencent/Hunyuan3D-2 --subfolder hunyuan3d-dit-v2-0-turbo --texgen_model_path tencent/Hunyuan3D-2 --low_vram_mode --enable_flashvdm --enable_t23d --port \$port" >> hunyuan.sh
chmod +x hunyuan.sh
echo -e \#\!"/bin/bash\nexport PATH=\"$PWD/${pydir[$pyver]}/bin:\$PATH\"\nexport FLASH_ATTENTION_TRITON_AMD_ENABLE=\"TRUE\"\nexport GPU_ARCHS=\"gfx1100\"\nport=\`cat ../port\`\npython3 gradio_app.py --model_path tencent/Hunyuan3D-2mv --subfolder hunyuan3d-dit-v2-mv-turbo --texgen_model_path tencent/Hunyuan3D-2 --low_vram_mode --enable_flashvdm --port \$port" >> hunyuan-mv.sh
chmod +x hunyuan-mv.sh
echo -e "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Hunyuan3D-2\nComment=\nExec=$PWD/hunyuan.sh\nIcon=$PWD/icon.png\nPath=$PWD/Hunyuan3D-2/\nTerminal=true\nStartupNotify=false" >> Hunyuan3D-2.desktop
chmod +x Hunyuan3D-2.desktop
echo -e "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Hunyuan3D-2 Multiview\nComment=\nExec=$PWD/hunyuan-mv.sh\nIcon=$PWD/icon.png\nPath=$PWD/Hunyuan3D-2/\nTerminal=true\nStartupNotify=false" >> Hunyuan3D-2-Multiview.desktop
chmod +x Hunyuan3D-2-Multiview.desktop
rm -rf pyvers
rm -rf wheels
rm -rf flash-attention
mv -f gradio_app.py Hunyuan3D-2/gradio_app.py
rm  requirements.txt
rm  README.md
rm  INSTALL.sh
