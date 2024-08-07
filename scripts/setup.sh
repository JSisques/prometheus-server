#!/bin/bash

# Paso 1: Actualizar apt-get
echo "Paso 1: Actualizando apt-get..."
sudo apt-get update
echo "apt-get actualizado."

# Paso 2: Upgradear el sistema
echo "Paso 2: Upgrandeando el sistema..."
sudo apt-get upgrade -y
echo "Sistema upgrandeado."

# Paso 3: Verificar e instalar Docker si no está presente
if ! command -v docker &> /dev/null; then
    echo "Paso 3: Docker no está instalado. Instalando Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "Docker instalado y usuario añadido al grupo docker."
else
    echo "Paso 3: Docker ya está instalado."
fi

# Paso 4: Verificar e instalar Docker Compose si no está presente
if ! command -v docker-compose &> /dev/null; then
    echo "Paso 4: Docker Compose no está instalado. Instalando Docker Compose..."
    sudo apt-get install docker-compose -y
    echo "Docker Compose instalado."
else
    echo "Paso 4: Docker Compose ya está instalado."
fi

# Paso 5: Ejecutar Docker Compose para iniciar el servidor de Prometheus
echo "Paso 5: Iniciando el servidor de Prometheus con Docker Compose..."
docker-compose up -d
echo "El servidor de Prometheus se está ejecutando en segundo plano."