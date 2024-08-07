#!/bin/bash

# Variables
USER_DIR="/home/$USER/prometheus-server"
SOURCE_DIR="$USER_DIR/data"
BACKUP_DIR="$USER_DIR/backups"
TIMESTAMP=$(date +"%Y-%m-%d")
BACKUP_FILE="$TIMESTAMP.tar.gz"
CONFIG_FILES=(
    "$USER_DIR/config/prometheus.yml"
    "$USER_DIR/config/rules.yml"
    "$USER_DIR/config/alertmanager.yml"
    "$USER_DIR/.env"
)

# Crear directorio de respaldo si no existe
mkdir -p "$BACKUP_DIR"

# Copiar archivos de configuración al directorio de respaldo si existen
for file in "${CONFIG_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "Copiando archivo de configuración: $file"
        cp "$file" "$BACKUP_DIR/"
    else
        echo "Archivo de configuración no encontrado: $file"
    fi
done

# Realizar la copia de seguridad de la carpeta principal
echo "Realizando la copia de seguridad de $SOURCE_DIR..."
tar -zcvf "$BACKUP_DIR/$BACKUP_FILE" -C "$BACKUP_DIR" .

# Imprimir mensaje de éxito
echo "Copia de seguridad realizada con éxito: $BACKUP_DIR/$BACKUP_FILE"

# Eliminar copias de seguridad que tengan más de 7 días
find "$BACKUP_DIR" -name "*.tar.gz" -type f -mtime +7 -exec rm -f {} \;

# Imprimir mensaje de limpieza de copias antiguas
echo "Copias de seguridad de más de 7 días eliminadas."
