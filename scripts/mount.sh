#!/bin/sh

# Función para mostrar el mensaje de ayuda
mostrar_ayuda() {
    echo "Uso: $0 -server <IP-servidor> -folder <nombre_de_carpeta> -mountpoint <punto_de_montura> [-user <usuario>] [-password <contraseña>]"
    echo ""
    echo "Montar un volumen en red utilizando CIFS y añadir la entrada al archivo /etc/fstab."
    echo ""
    echo "Opciones:"
    echo "  -server <IP-servidor>     Dirección IP del servidor de archivos."
    echo "  -folder <nombre_de_carpeta> Nombre de la carpeta compartida en el servidor."
    echo "  -mountpoint <punto_de_montura> Directorio local donde se montará el volumen."
    echo "  -user <usuario>          Nombre de usuario para la autenticación (opcional)."
    echo "  -password <contraseña>   Contraseña para la autenticación (opcional)."
    echo "  -help                    Mostrar esta ayuda y salir."
}

# Función para procesar los parámetros
procesar_parametros() {
    echo "Procesando parámetros..."
    while [ "$#" -gt 0 ]; do
        case "$1" in
            -server)
                IP_SERVIDOR="$2"
                echo "Servidor de archivos establecido en $IP_SERVIDOR"
                shift 2
                ;;
            -folder)
                NOMBRE_CARPETA="$2"
                echo "Nombre de la carpeta compartida establecido en $NOMBRE_CARPETA"
                shift 2
                ;;
            -mountpoint)
                PUNTO_MONTURA="$2"
                echo "Punto de montaje local establecido en $PUNTO_MONTURA"
                shift 2
                ;;
            -user)
                USUARIO="$2"
                echo "Usuario para autenticación establecido en $USUARIO"
                shift 2
                ;;
            -password)
                CONTRASENA="$2"
                echo "Contraseña para autenticación establecida."
                shift 2
                ;;
            -help)
                mostrar_ayuda
                exit 0
                ;;
            *)
                echo "Error: Parámetro desconocido: $1"
                mostrar_ayuda
                exit 1
                ;;
        esac
    done
}

# Procesar los parámetros
echo "Inicio del script..."
procesar_parametros "$@"

# Validar que se hayan proporcionado los parámetros obligatorios
echo "Validando parámetros..."
if [ -z "$IP_SERVIDOR" ] || [ -z "$NOMBRE_CARPETA" ] || [ -z "$PUNTO_MONTURA" ]; then
    echo "Error: Faltan parámetros obligatorios."
    mostrar_ayuda
    exit 1
fi

# Variables
FSTAB_ENTRY="//${IP_SERVIDOR}/${NOMBRE_CARPETA} ${PUNTO_MONTURA} cifs"

# Verificar si el punto de montaje ya existe
echo "Verificando si el punto de montaje $PUNTO_MONTURA existe..."
if [ ! -d "$PUNTO_MONTURA" ]; then
    echo "El punto de montaje $PUNTO_MONTURA no existe. Creándolo..."
    sudo mkdir -p "$PUNTO_MONTURA"
else
    echo "El punto de montaje $PUNTO_MONTURA ya existe."
fi

# Intentar montar el volumen
MOUNT_CMD="sudo mount -t cifs //${IP_SERVIDOR}/${NOMBRE_CARPETA} ${PUNTO_MONTURA}"

if [ -n "$USUARIO" ]; then
    MOUNT_CMD="${MOUNT_CMD} -o user=${USUARIO},password=${CONTRASENA},vers=3.0"
    echo "Configurando montaje con usuario ${USUARIO} y contraseña."
else
    echo "Configurando montaje sin autenticación de usuario."
fi

echo "Ejecutando el comando de montaje: $MOUNT_CMD"
if eval $MOUNT_CMD; then
    echo "Volumen montado correctamente en ${PUNTO_MONTURA}."
else
    echo "Error al montar el volumen."
    exit 1
fi

# Verificar si la entrada en /etc/fstab ya existe
echo "Verificando si la entrada existe en /etc/fstab..."
if grep -q "${FSTAB_ENTRY}" /etc/fstab; then
    echo "La entrada ya existe en /etc/fstab."
else
    echo "La entrada no existe en /etc/fstab. Añadiéndola..."
    if [ -n "$USUARIO" ]; then
        echo "${FSTAB_ENTRY} -o username=${USUARIO},password=${CONTRASENA},vers=3.0" | sudo tee -a /etc/fstab > /dev/null
    else
        echo "${FSTAB_ENTRY}" | sudo tee -a /etc/fstab > /dev/null
    fi
    echo "Entrada añadida a /etc/fstab."
fi
