#!/bin/bash

#Ask user for GPU
echo "Enter your AMD GPU name (e.g.: gfx1102): "
read gpu


#Compile custom_rasterizer module specific to this container
apt-get update
apt-get install -y build-essential python3.10-dev


#Install requirements
python3 -m ensurepip
python3 -m pip install torch==2.7.1 torchvision==0.22.1 torchaudio==2.7.1 --index-url https://download.pytorch.org/whl/rocm6.3
python3 -m pip install -r requirements.txt
python3 -m pip install mmgp

#Configure for AMD GPus
export FLASH_ATTENTION_TRITON_AMD_ENABLE="TRUE"
export GPU_ARCHS=$gpu
git clone --single-branch --branch main_perf https://github.com/ROCm/flash-attention.git
cd flash-attention/
python3 -m pip install sentencepiece packaging
python3 setup.py install
cd ..

#Clone and configure original repo
git clone https://github.com/Tencent-Hunyuan/Hunyuan3D-2.git
cd Hunyuan3D-2
python3 -m pip install -e .
cd hy3dgen/texgen/differentiable_renderer/
python3 setup.py install


# Build & install custom_rasterizer (this replaces the prebuilt wheel!)
cd ../custom_rasterizer/
python3 setup.py bdist_wheel
python3 -m pip install dist/*.whl

cd ../../../../

# Other Python deps
python3 -m pip install gradio==5.33.0 opencv-python==4.9.0.80 opencv-python-headless==4.10.0.84 numpy==1.26.4 jmespath

#Ask user for desired port
echo "What port do you want this app to use?"
read port

#Create hunyuan.sh
echo -e \#\!"/bin/bash\nexport FLASH_ATTENTION_TRITON_AMD_ENABLE=\"TRUE\"\nexport GPU_ARCHS=\"$gpu\"\npython3 gradio_app.py --model_path tencent/Hunyuan3D-2 --subfolder hunyuan3d-dit-v2-0-turbo --texgen_model_path tencent/Hunyuan3D-2 --low_vram_mode --enable_flashvdm --enable_t23d --port $port" >> hunyuan.sh

chmod +x hunyuan.sh

#Create hunyuan-mv.sh
echo -e \#\!"/bin/bash\nexport FLASH_ATTENTION_TRITON_AMD_ENABLE=\"TRUE\"\nexport GPU_ARCHS=\"$gpu\"\npython3 gradio_app.py --model_path tencent/Hunyuan3D-2mv --subfolder hunyuan3d-dit-v2-mv-turbo --texgen_model_path tencent/Hunyuan3D-2 --low_vram_mode --enable_flashvdm --port $port" >> hunyuan-mv.sh
chmod +x hunyuan-mv.sh

#Clean up
rm -rf wheels
rm -rf flash-attention
mv -f gradio_app.py Hunyuan3D-2/gradio_app.py
mv -f hunyuan.sh Hunyuan3D-2/hunyuan.sh
mv -f hunyuan-mv.sh Hunyuan3D-2/hunyuan-mv.sh
rm  requirements.txt
rm  README.md
rm  INSTALL.sh
