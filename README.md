# network-lab
Network lab in docker. GNS3, Wireshark, Grafana.

# 🌐 Laboratorio de Redes Virtualizado (GNS3 + Stack de Monitoreo)

Este proyecto despliega un entorno completo de emulación de redes utilizando **GNS3**, junto con una suite de herramientas profesionales para el análisis de tráfico (**Wireshark**) y monitoreo de rendimiento (**Prometheus** y **Grafana**).

---

## 🚀 Servicios y Acceso

Una vez desplegado el entorno con `docker-compose up -d`, puedes acceder a las herramientas mediante las siguientes direcciones:

| Servicio | Acceso Web | Función |
| :--- | :--- | :--- |
| **GNS3 Server** | [http://localhost:3080](http://localhost:3080) | Motor de emulación de red. |
| **Wireshark** | [http://localhost:3008/vnc.html](http://localhost:3008/vnc.html) | Análisis de paquetes en tiempo real. |
| **Grafana** | [http://localhost:3002](http://localhost:3002) | Dashboards y visualización de datos. |
| **Prometheus** | [http://localhost:9090](http://localhost:9090) | Base de datos de métricas. |

---

## 📂 Gestión de Capturas de Tráfico

El contenedor de **Wireshark** está sincronizado con los proyectos de **GNS3**. Para analizar el tráfico de tus dispositivos:

1. **Iniciar Captura:** En la interfaz de GNS3, haz clic derecho sobre un enlace y selecciona *Start Capture*.
2. **Abrir en Wireshark:**
   - Accede a la interfaz web de Wireshark (Puerto 3008).
   - Haz clic en el icono **Open** (o `File > Open`).
   - Navega a la ruta: `/storage/gns3-projects/`.
   - Busca la carpeta de tu proyecto (identificada por un ID único) y entra en `project-files/captures/`.
   - Selecciona el archivo `.pcap` deseado.

---

## 📊 Monitoreo (SNMP)

El laboratorio incluye un flujo de métricas automatizado:
* **SNMP Exporter:** Consulta los dispositivos activos en GNS3.
* **Prometheus:** Almacena los datos históricos recolectados.
* **Grafana:** Permite crear gráficas de tráfico, CPU y memoria. 
  *(Credenciales por defecto: `admin` / `admin`)*.

---

## 🛠️ Estructura del Proyecto

Los datos se guardan de forma persistente en tu máquina local para que no pierdas el trabajo al reiniciar los contenedores:

* `/projects`: Archivos de topología y capturas `.pcap`.
* `/images`: Imágenes de sistemas operativos (IOS, QEMU, etc.).
* `/config`: Archivos de configuración del servidor GNS3.
* `/prometheus.yml`: Configuración de los objetivos de monitoreo.

---

## ⚠️ Notas Técnicas

* **Permisos:** Si no puedes ver los archivos desde la web de Wireshark, asegúrate de que la carpeta local `projects` tenga permisos de lectura:  
  `chmod -R 755 ./projects`
* **VNC:** Al entrar en la URL de Wireshark, haz clic en el botón **"Connect"** para activar la transmisión de video.
* **Modo Privilegiado:** El servidor GNS3 corre en modo `privileged` para permitir la aceleración KVM de los nodos.
