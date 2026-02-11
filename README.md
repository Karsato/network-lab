# network-lab
Network lab in PODMAN or DOCKER. GNS3, Wireshark, Grafana.

## Routers
Hay que crear un nuevo dispositivo con la imagen de OpenWRT 24.10.
Primero hay que crear un proyecto de test, importar la imagen de OpenWRT 24.10 y llamarla "openwrt 24.10".
Después se importa el proyecto y crea una red de 3 niveles. Capa de acceso, capa de transporte y núcleo.
Solo están configurados los routers L0R0, L1R0, L2R0 y PC1.
Para configurar el resto, ver L0R0.sh, L1R0.sh, L2R0.sh y cambiar las ips como se indica en el esquema.

Hay que configurar una red de docker:
docker network create --subnet=172.50.0.0/24 gns3_gf

Después averiguamos cual es el nombre del adaptador:
ip addr | grep 172.50.0.1                               
    inet 172.50.0.1/24 brd 172.50.0.255 scope global br-dad0cdbac20b

Con el id del adaptador "br-dad0cdbac20b" en este caso. Quitamos el nodo cloud que trae el proyecto ycreamos un nuevo nodo cloud. Conectamos el nuevo nodo cloud con el router L0R0 desde ethernet0 al cloud "br-dad0cdbac20b" o el que tenga cada uno en su caso. Esto hará que nuestra red tenga salida a internet. 


---------------

## 🛠️ Versión PODMAN: Despliegue en Podman

Si utilizas **Podman**, puedes emplear una arquitectura de **red compartida** (`network_mode: service`). Esta configuración es más eficiente ya que todos los servicios de análisis y monitoreo se "inyectan" en el espacio de red del servidor GNS3.

### 🔗 Enlaces de Acceso Directo (Modo Podman)

| Servicio | Enlace de Acceso | Función |
| :--- | :--- | :--- |
| **GNS3 Web** | [http://localhost:3080](http://localhost:3080) | Servidor y gestión de nodos. |
| **Wireshark Web** | [http://localhost:3001](http://localhost:3001) | Análisis de paquetes (VNC). |
| **Grafana** | [http://localhost:3002](http://localhost:3002) | Visualización de métricas. |
| **Prometheus** | [http://localhost:9090](http://localhost:9090) | Base de datos de telemetría. |

---

### 🧠 Conceptos Clave de esta Configuración



#### 1. Red Unificada (`network_mode: service`)
A diferencia de Docker estándar, aquí todos los contenedores auxiliares (Wireshark, Grafana, etc.) se vinculan a la interfaz de red de `gns3-server`. Esto permite que:
* Wireshark pueda ver directamente las interfaces virtuales del servidor.
* No existan conflictos de puertos entre contenedores, ya que todos se exponen a través del servicio principal.

#### 2. Permisos y Volúmenes (`:Z`)
En entornos con **SELinux** (común al usar Podman), el flag `:Z` es crítico. Permite que Podman reetiquete automáticamente los volúmenes para que varios contenedores puedan leer y escribir en `./gns3-data` sin errores de "Permission Denied".

#### 3. Flujo de Análisis de Tráfico
* **Captura:** GNS3 escribe los archivos `.pcap` en `./gns3-data/projects`.
* **Inspección:** Wireshark accede a esos archivos a través del punto de montaje `/captures`.
* **Telemetría:** El servicio `packet-exporter` monitoriza el tráfico en tiempo real usando `tshark` y lo prepara para ser procesado por el stack de monitoreo.

---

### 🚀 Instrucciones de Inicio

1. **Levantar el entorno:**
   ```bash
   podman-compose up -d
---------------
 
## Versión DOCKER : 🌐 Laboratorio de Redes Virtualizado (GNS3 + Stack de Monitoreo)

Este proyecto despliega un entorno completo de emulación de redes utilizando **GNS3**, junto con una suite de herramientas profesionales para el análisis de tráfico (**Wireshark**) y monitoreo de rendimiento (**Prometheus** y **Grafana**).

---

### 🚀 Servicios y Acceso

Una vez desplegado el entorno con `docker-compose up -d`, puedes acceder a las herramientas mediante las siguientes direcciones:

| Servicio | Acceso Web | Función |
| :--- | :--- | :--- |
| **GNS3 Server** | [http://localhost:3080](http://localhost:3080) | Motor de emulación de red. |
| **Wireshark** | [http://localhost:3008/vnc.html](http://localhost:3008/vnc.html) | Análisis de paquetes en tiempo real. |
| **Grafana** | [http://localhost:3002](http://localhost:3002) | Dashboards y visualización de datos. |
| **Prometheus** | [http://localhost:9090](http://localhost:9090) | Base de datos de métricas. |

---

### 📂 Gestión de Capturas de Tráfico

El contenedor de **Wireshark** está sincronizado con los proyectos de **GNS3**. Para analizar el tráfico de tus dispositivos:

1. **Iniciar Captura:** En la interfaz de GNS3, haz clic derecho sobre un enlace y selecciona *Start Capture*.
2. **Abrir en Wireshark:**
   - Accede a la interfaz web de Wireshark (Puerto 3008).
   - Haz clic en el icono **Open** (o `File > Open`).
   - Navega a la ruta: `/storage/gns3-projects/`.
   - Busca la carpeta de tu proyecto (identificada por un ID único) y entra en `project-files/captures/`.
   - Selecciona el archivo `.pcap` deseado.

---

### 📊 Monitoreo (SNMP)

El laboratorio incluye un flujo de métricas automatizado:
* **SNMP Exporter:** Consulta los dispositivos activos en GNS3.
* **Prometheus:** Almacena los datos históricos recolectados.
* **Grafana:** Permite crear gráficas de tráfico, CPU y memoria. 
  *(Credenciales por defecto: `admin` / `admin`)*.

---

### 🛠️ Estructura del Proyecto

Los datos se guardan de forma persistente en tu máquina local para que no pierdas el trabajo al reiniciar los contenedores:

* `/projects`: Archivos de topología y capturas `.pcap`.
* `/images`: Imágenes de sistemas operativos (IOS, QEMU, etc.).
* `/config`: Archivos de configuración del servidor GNS3.
* `/prometheus.yml`: Configuración de los objetivos de monitoreo.

---

### ⚠️ Notas Técnicas

* **Permisos:** Si no puedes ver los archivos desde la web de Wireshark, asegúrate de que la carpeta local `projects` tenga permisos de lectura:  
  `chmod -R 755 ./projects`
* **VNC:** Al entrar en la URL de Wireshark, haz clic en el botón **"Connect"** para activar la transmisión de video.
* **Modo Privilegiado:** El servidor GNS3 corre en modo `privileged` para permitir la aceleración KVM de los nodos.
