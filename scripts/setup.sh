#!/bin/bash

# Función para añadir una entrada al crontab si no existe
add_cron() {
    local cron_line="$1"
    local cron_file="/etc/crontab"

    if ! grep -qF "$cron_line" "$cron_file"; then
        echo "Añadiendo al crontab: $cron_line"
        echo "$cron_line" | sudo tee -a "$cron_file" > /dev/null
    else
        echo "La entrada ya existe en el crontab: $cron_line"
    fi
}

# Paso 1: Actualizar apt-get
echo "Paso 1: Actualizando apt-get..."
sudo apt-get update
echo "apt-get actualizado."

# Paso 2: Upgradear el sistema
echo "Paso 2: Upgrandeando el sistema..."
sudo apt-get upgrade -y
echo "Sistema upgrandeado."

# Paso 2.1: Eliminar paquetes no necesarios
echo "Paso 2.1: Eliminando paquetes no necesarios..."
sudo apt autoremove -y
echo "Paquetes no necesarios eliminados."

# Paso 3: Verificar e instalar Docker si no está presente
if ! command -v docker &> /dev/null; then
    echo "Paso 3: Docker no está instalado. Instalando Docker..."
    sudo curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    echo "Docker instalado y usuario añadido al grupo docker."
else
    echo "Paso 3: Docker ya está instalado. Actualizando Docker..."
    sudo curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    echo "Docker actualizado."
fi

# Paso 4: Verificar e instalar Docker Compose si no está presente
if ! command -v docker-compose &> /dev/null; then
    echo "Paso 4: Docker Compose no está instalado. Instalando Docker Compose..."
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose instalado a la versión $DOCKER_COMPOSE_VERSION."
else
    echo "Paso 4: Docker Compose ya está instalado. Actualizando Docker Compose..."
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose actualizado a la versión $DOCKER_COMPOSE_VERSION."
fi

# Paso 5: Ejecutar Docker Compose para iniciar el servidor de Prometheus
echo "Paso 5: Iniciando el servidor de Prometheus con Docker Compose..."
docker-compose up -d
echo "El servidor de Prometheus se está ejecutando en segundo plano."

# Paso 6: Añadir entradas al crontab
echo "Paso 6: Añadiendo entradas al crontab..."

# Línea para reiniciar el sistema a las 08:00 una vez por semana
add_cron "00 8    * * 0   root    reboot"

# Línea para ejecutar el script de backup a las 07:00 todos los días
add_cron "00 7    * * *   root    sh /home/javi/prometheus-server/scripts/backup.sh"

echo "Entradas añadidas al crontab (si no estaban ya presentes)."
