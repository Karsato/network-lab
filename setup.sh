#!/bin/bash

# Configuracion
IMG_NAME="openwrt-24.10.2-x86-64-generic-ext4-combined.img"
URL="https://downloads.openwrt.org/releases/24.10.2/targets/x86/64/${IMG_NAME}.gz"
TARGET_DIR="./images/QEMU"

# 1. Corregir permisos de la carpeta actual si es necesario
# Esto evita el error de 'Permiso denegado' si Docker creo carpetas como root
sudo chown -R $USER:$USER .

# 2. Crear estructura de directorios
mkdir -p "$TARGET_DIR"

# 3. Descarga y descompresion
if [ ! -f "$TARGET_DIR/$IMG_NAME" ]; then
  echo "Iniciando descarga de OpenWrt 24.10.2..."
  curl -L "$URL" -o "$TARGET_DIR/${IMG_NAME}.gz"

  echo "Descomprimiendo archivo..."
  gunzip -f "$TARGET_DIR/${IMG_NAME}.gz"

  # Asegurar que el motor QEMU pueda leer la imagen
  chmod 644 "$TARGET_DIR/$IMG_NAME"
  echo "Imagen preparada correctamente."
else
  echo "La imagen ya existe en el directorio de destino."
fi

# 4. Despliegue de contenedores
echo "Iniciando servicios con Docker Compose..."
docker compose -f docker-compose.yml up -d
