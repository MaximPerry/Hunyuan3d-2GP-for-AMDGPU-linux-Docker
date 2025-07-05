# Hunyuan3D-2 for AMDGPU in linux
This is a shell script to download and configure Hunyuan3D-2 locally on a linux computer with an AMD GPU.
To make it works yo must have previously installed ROCM (i've used ROCM 6.4.1 but maybe it can work with other versions).

The main problem to make it work is the compilation step of custom_rasterizer, so i provide python wheels compiled for python version 3.10 and 3.13.

I'm using Ubuntu, but for some reason i was only able to succeed in the compilation in ArchLinux. Once custom_rasterizer is compiled and installed, i can run Hunyuan3D from Ubuntu with no problem.
