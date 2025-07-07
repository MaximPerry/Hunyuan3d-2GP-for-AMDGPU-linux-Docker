[English-Inglés](README.md)
# Hunyuan3D-2 para GPU AMD
Este es un script para descargar y configurar Hunyuan3D-2 de manera local en un ordenador con una trajeta gráfica AMD.

Para que funcione tienesw que instalar primero ROCM (Yo he usado ROCM 6.4.1, pero es posible que funcione con otras versiones). He utilizado una RX 7900 XTX, si utilizas otro modelo de tarjeta gráfica, es posible que necesites algunas modificaciones más.

El mayor problema para hacerlo funcionar es compilar el módulo custom_rasterizer, ya que necesita CUDA. En este repositorio he subido las wheels de Python para las versiones 3.10 y 3.13.

Yo utilizo Ubuntu y por alguna razón el proceso de compilado falla, lo he conseguido realizando la compilación desde Archlinux. Una vez tengo las wheels compiladas, he podido installarlas en Ubuntu sin problemas.

En este repositorio hay unas versiones precompiladas de Python para automatizar todo el proceso de instalación.

## Requisitos

Necesitas installar ROCM y unas pocas dependencias.
```
sudo apt-get install git yad
```

[Install ROCM](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/quick-start.html)

## Instalación
Una vez has instalado las dependencias, puedes clonar este repositorio y ejecutar el script de Instalación.

```
git clone https://github.com/dgarcia1985/Hunyuan3d-2-for-AMDGPU-linux.git
cd Hunyuan3d-2-for-AMDGPU-linux
./INSTALL.sh
```

Espera a que el Script de installación descarge e instale todas las dependencias.
Te preguntará que versión de Python quieres utilizar y que puerto vas a seleccionar para la applicación Gradio local.
## Problemas conocidos
La generación de modelos fallará si en la ruta desde la que se ejecuta Hunyuan3D-2 contiene espacios. Creo que está relacionado con este problema [[Issue]: ROCm 6.x doesn't work with space in the path #4329
](https://github.com/ROCm/ROCm/issues/4329)

## Ejecución
Una vez instalado, deberías tener dos archivos .desktop en la carpeta Hunyuan3d-2-for-AMDGPU-linux.
Estos archivos ejecutarán Hunyuan3D-2 en su modo de una única imagen o multivista. EL modo de imagen única también puede generar modelos 3D a partir de texto.
