![Banner](./img/prometheus-server.png)

# 📊 Prometheus Server

Prometheus Server es un repositorio que facilita la configuración de un servidor Prometheus, junto con Node Exporter y Alertmanager, utilizando Docker Compose.

## 📝 Descripción

Este repositorio contiene un Docker Compose que configura un entorno completo de monitoreo con Prometheus, Node Exporter y Alertmanager. Incluye archivos de configuración para Prometheus (`prometheus.yml` y `rules.yml`) y Alertmanager (`alertmanager.yml`).

## 🛠️ Instalación

### Requisitos

- Docker
- Docker Compose

### Pasos

1. Clona este repositorio:

```bash
git clone https://github.com/tu-usuario/prometheus-server.git
```

2. Navega hasta el directorio del repositorio:

```bash
cd prometheus-server
```

3. Modifica los archivos de configuración según sea necesario:

- `prometheus.yml`: Configura los targets y reglas de Prometheus.
- `rules.yml`: Define las reglas de alerta para Prometheus.
- `alertmanager.yml`: Configura las notificaciones de alertas en Alertmanager.

4. Ejecuta Docker Compose para iniciar los servicios:

```bash
docker-compose up -d
```

Esto iniciará los contenedores de Prometheus Server, Node Exporter y Alertmanager en segundo plano.

## 🚀 Uso

Una vez que los contenedores estén en ejecución, puedes acceder a las siguientes interfaces:

- Prometheus: [http://localhost:9090](http://localhost:9090)
- Node Exporter: [http://localhost:9100/metrics](http://localhost:9100/metrics)
- Alertmanager: [http://localhost:9093](http://localhost:9093)

## 👨‍💻 Autor

- Nombre: Javier Plaza Sisqués
- GitHub: JSisques

## 📄 Archivos de Configuración

En este repositorio se incluyen varios archivos de configuración para personalizar el comportamiento de Prometheus y Alertmanager:

- `prometheus.yml`: Configuración principal de Prometheus.
- `rules.yml`: Reglas de alerta personalizadas para Prometheus.
- `alertmanager.yml`: Configuración de notificaciones para Alertmanager.

¡Empieza a monitorear tus aplicaciones y sistemas con Prometheus de manera sencilla! 🎉
