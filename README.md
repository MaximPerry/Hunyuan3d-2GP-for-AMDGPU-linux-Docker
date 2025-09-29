[Español-Spanish](README-ES.md)
# Hunyuan3D-2 for AMDGPU in linux
This is a shell script to download and configure Hunyuan3D-2GP locally on a linux computer with an AMD GPU inside of Docker, more specifically in the context of CasaOS.

Credits to @dgarcia1985 for creating the original version (none-docker): [Hunyuan3d-2-for-AMDGPU-linux](https://github.com/dgarcia1985/Hunyuan3d-2-for-AMDGPU-linux)

This was tested on the following system:
- Ubuntu Server 22.04 LTS with CasaOS;
- GPU: AMD Radeon 7600 XT (gfx1102)
- ROCM: Version 6.10.5 (on host)


## Prerequisites
1. Make sure AMD drivers are installed on host, with [ROCM support](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/quick-start.html);


## Installation
1. Create a new Docker container using the [ROCM + Pytorch](https://hub.docker.com/r/rocm/pytorch) image:
```
docker run -it --name hunyuan3d \
  --network=host \
  --device=/dev/kfd \
  --device=/dev/dri \
  --group-add=video \
  --ipc=host \
  --cap-add=SYS_PTRACE \
  --security-opt seccomp=unconfined \
  -v /DATA/AppData/Hunyuan3D-2:/dockerx \
  rocm/pytorch:rocm6.4.3_ubuntu22.04_py3.10_pytorch_release_2.6.0
```
This will create the docker container, and should bring you directly insider the shell of this newly created container.

2. From inside the container, clone this repo:
```
cd /dockerx
git clone https://github.com/MaximPerry/Hunyuan3d-2-for-AMDGPU-linux-Docker.git
```

3. Run the install script:
```
cd Hunyuan3d-2-for-AMDGPU-linux-Docker
chmod +x INSTALL.sh
./INSTALL.sh
```
You will be asked for the the name of your AMD GPU, and the port you wish to use as host the app.
Wait to the installation script to download and install all dependencies.

## Launching Hunyuan3D-2
Once installed, you can launch either hunyuan.sh (text / single image to 3D model) or hunyuan-mv.sh (multi images to 3D model) located in the newly created folder:
```
cd Hunyuan3D-2GP
./hunyuan.sh
```
... or ...
```
cd Hunyuan3D-2GP
./hunyuan-mv.sh
```

## Final setup for CasaOS
Now, we have a container that works, but we need to manually launch Hunyuan3D-2 every time the container starts. Let's officially import it to CasaOS and make it run automatically.

## Known issues
Model generation will fail if the folder from wich you run Hunyuan got spaces.
I think is related to this issue [[Issue]: ROCm 6.x doesn't work with space in the path #4329
](https://github.com/ROCm/ROCm/issues/4329)

Current Torch 2.8 doesn't work. Previous version 2.8.0.dev20250525+rocm6.4 used to work but it is no longer available. With torch 2.7.0 version it works.

Texture generation fails when integrated+dedicated gpus are present. Disabling it in bios fixed this issue.


