# Configuracion
IMG_NAME="openwrt-24.10.2-x86-64-generic-ext4-combined.img"
URL="https://downloads.openwrt.org/releases/24.10.2/targets/x86/64/${IMG_NAME}.gz"
TARGET_DIR="./images/QEMU"

# 1. Comprobar si tenemos permisos de escritura en el directorio actual
if [ ! -w "." ]; then
    echo "Error: No hay permisos de escritura en este directorio."
    exit 1
fi

# 2. Crear estructura de directorios
mkdir -p "$TARGET_DIR"

# 3. Descarga y descompresion
if [ ! -f "$TARGET_DIR/$IMG_NAME" ]; then
    echo "Descargando OpenWrt 24.10.2..."
    if curl -L "$URL" -o "$TARGET_DIR/${IMG_NAME}.gz"; then
        echo "Descomprimiendo archivo..."
        gunzip -f "$TARGET_DIR/${IMG_NAME}.gz"

        # Permisos de lectura para que el proceso QEMU acceda a la imagen
        chmod 644 "$TARGET_DIR/$IMG_NAME"
        echo "Imagen preparada correctamente."
    else
        echo "Error al descargar la imagen de OpenWrt."
        exit 1
    fi
else
    echo "La imagen ya existe en $TARGET_DIR."
fi

# 4. Nota sobre ejecucion
echo "Preparacion completada. Puedes lanzar el entorno con:"
echo "make docker-up  O  make podman-up"
