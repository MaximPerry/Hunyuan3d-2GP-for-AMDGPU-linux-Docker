[Español-Spanish](README-ES.md)
# Hunyuan3D-2 for AMDGPU in linux
This is a shell script to download and configure Hunyuan3D-2 locally on a linux computer with an AMD GPU.
To make it works yo must have previously installed ROCM (i've used ROCM 6.4.1 but maybe it can work with other versions). I've used a RX 7900 XTX, if you own other models further modifications may be needed.

The main problem to make it work is the compilation step of custom_rasterizer, so i provide python wheels compiled for python version 3.10 and 3.13.

I'm using Ubuntu, but for some reason i was only able to succeed in the compilation in ArchLinux. Once custom_rasterizer is compiled and installed, i can run Hunyuan3D from Ubuntu with no problem.

## Requirements

Yo need to install Rocm and a few dependencies.
```
sudo apt-get install git yad
```

[Install ROCM](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/quick-start.html)

## Installation
Once you got the dependencies you can clone this repo and execute the Install Script.
```
git clone https://github.com/dgarcia1985/Hunyuan3d-2-for-AMDGPU-linux.git
cd Hunyuan3d-2-for-AMDGPU-linux
./INSTALL.sh
```

Wait to the installation script to download and install all dependencies.
You will be asked to select which python version you want to use and the port you wish to use as host to the local Gradio App.

## Execution
Once installed, you will have two .desktop files in the Hunyuan3d-2-for-AMDGPU-linux Folder.
These files will run Hunyuan3D-2 in single view mode or multiview mode. Single view mode will also be able to generate 3D models from text input.
