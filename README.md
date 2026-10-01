# Inception-Of-Things
Persona 1: Datos, Mensajería e Ingesta (IoT Core)

    • Parte Obligatoria (100%):
        ◦ Simulador IoT: Contenedor (Python/C) que genera métricas simuladas (temperatura, humedad, estado) y las envía por red.
        ◦ Broker MQTT: Instancia de Mosquitto con autenticación por credenciales/certificados para recibir la telemetría.
        ◦ Base de datos Time-Series: InfluxDB configurada para almacenar el flujo de datos persistente.
    • Aporte al Bonus (+25%):
        ◦ Servicio Web Extra (Producción): Despliegue de una app web (ej. API en Node.js/Python o WordPress) que consulte la base de datos de los sensores y muestre información en tiempo real.

Persona 2: Cluster, Red e Infraestructura (K8s / SysAdmin)

    • Parte Obligatoria (100%):
        ◦ Entorno de Red / Nodos: Script o Makefile para levantar el clúster con K3s / K3d (o Vagrant) de forma reproducible con un solo comando.
        ◦ Controlador de Ingress: Traefik o NGINX Ingress para enrutar el tráfico externo hacia los servicios internos con certificados SSL.
        ◦ Persistencia y Seguridad Basica: Definición de PersistentVolumeClaims (PVC) para que no se pierdan datos si cae un pod.
    • Aporte al Bonus (+25%):
        ◦ GitLab Self-Hosted: Despliegue de una instancia privada de GitLab dentro del clúster con sus propios recursos y volúmenes aislados.

Persona 3: Despliegue Automatizado y Métricas (DevOps & GitOps)

    • Parte Obligatoria (100%):
        ◦ Argo CD (GitOps): Instalación y vinculación de Argo CD con el repositorio del proyecto para sincronizar manifiestos YAML en tiempo real.
        ◦ Visualización: Grafana configurado mediante provisión automática de dashboards para ver los gráficos de los sensores de P1.
        ◦ Gestión de Secretos: Integración de Vault o Sealed Secrets para no subir contraseñas en texto plano a Git.
    • Aporte al Bonus (+25%):
        ◦ Pipeline CI/CD en GitLab: Creación del .gitlab-ci.yml con etapas de linting, build de imagen Docker y actualización automática del repositorio GitOps para activar el despliegue automático en Argo CD.
