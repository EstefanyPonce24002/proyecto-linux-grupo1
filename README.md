# Proyecto Linux Automatizado - Grupo 1

## Descripción General

Este proyecto forma parte de la asignatura **Introducción al Software Libre** y tiene como objetivo implementar un
**servidor Linux automatizado** mediante el uso de **Docker**, integrando prácticas de **administración de sistemas,
control de versiones y virtualización**.

El entorno fue configurado sobre **Debian 13 (Trixie)**, utilizando **Apache2** como servidor web principal,
en sustitución de Nginx debido a limitaciones de espacio en el sistema.

---

## 1. Preparación del Entorno Servidor

### 1.1 Administración Básica del Sistema

- Se asignó el nombre del host:
  ```bash
  sudo hostnamectl set-hostname servidor-grupo1
  ```
- Se crearon los usuarios:
  ```bash
  sudo adduser adminsys
  sudo adduser tecnico
  sudo adduser visitante
  ```
- Se crearon los grupos:
  ```bash
  sudo groupadd soporte
  sudo groupadd web
  ```
- Se asignaron los usuarios a los grupos:
  ```bash
  sudo usermod -aG sudo adminsys
  sudo usermod -aG soporte tecnico
  sudo usermod -aG web visitante
  ```

### 1.2 Estructura de Directorios y Permisos

Se creó la estructura base en `/proyecto/`:

```bash
sudo mkdir -p /proyecto/{datos,web,scripts,capturas}
```

Asignación de permisos de grupo:

```bash
sudo chown :soporte /proyecto/datos
sudo chown :web /proyecto/web
sudo chmod 2775 /proyecto/datos /proyecto/web
```

La opción `2` del modo `chmod` asegura que los archivos dentro de los directorios **hereden el grupo** del directorio padre.

---

## 2. Automatización y Monitoreo

### 2.1 Script de Monitoreo del Sistema

Se creó el archivo `/proyecto/scripts/reporte_sistema.sh` con el siguiente contenido:

```bash
#!/bin/bash
echo "===== REPORTE DEL SISTEMA ====="
echo "Fecha y hora actual: $(date)"
echo "Nombre del host: $(hostname)"
echo "Usuarios conectados: $(who | wc -l)"
echo "Espacio libre en disco (/): $(df -h / | awk 'NR==2{print $4}')"
echo "Memoria RAM disponible: $(free -h | awk '/Mem:/ {print $7}')"
echo "Contenedores Docker activos: $(docker ps -q | wc -l)"
echo "===================================="
```

Permisos de ejecución:

```bash
sudo chmod +x /proyecto/scripts/reporte_sistema.sh
```

Ejecución manual para prueba:

```bash
/proyecto/scripts/reporte_sistema.sh
```

---

### 2.2 Automatización con Cron

Se creó el directorio de logs:

```bash
sudo mkdir -p /var/log/proyecto
sudo chmod 775 /var/log/proyecto
```

Luego se editó el cron con:

```bash
sudo crontab -e
```

Y se añadió la siguiente línea:

```
*/30 * * * * /proyecto/scripts/reporte_sistema.sh >> /var/log/proyecto/reporte_sistema.log
```

Esto ejecuta el script cada **30 minutos** y almacena el resultado en `/var/log/proyecto/reporte_sistema.log`.

---

## 3. Control de Versiones

### 3.1 Inicialización del Repositorio Local

```bash
cd /proyecto/
git init
git add .
git commit -m "Primer commit - estructura inicial del proyecto"
```

### 3.2 Repositorio Remoto en GitHub

Se creó el repositorio remoto con el nombre:

```
proyecto-linux-grupo1
```

Y se vinculó con el repositorio local:

```bash
git remote add origin https://github.com/tu_usuario/proyecto-linux-grupo1.git
git branch -M main
git push -u origin main
```

---

## 4. Docker

### 4.1 Instalación y Configuración

Instalación del motor Docker:

```bash
sudo apt update
sudo apt install docker.io -y
```

Habilitar y verificar el servicio:

```bash
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker
```

Agregar los usuarios con permisos:

```bash
sudo usermod -aG docker adminsys
sudo usermod -aG docker tecnico
```

Verificar acceso sin sudo:

```bash
docker ps
```

### 4.2 Verificación Inicial

Probar contenedor base:

```bash
docker run hello-world
```

Listar contenedores activos:

```bash
docker ps -a
```

---

## 5. Servidor Web con Apache (Containerizado)

### 5.1 Archivo Web

Se creó un archivo `/proyecto/web/index.html`:

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Servidor Grupo 1</title>
  </head>
  <body>
    <h1>Servidor Automatizado con Apache y Docker</h1>
    <p>Proyecto Linux - Grupo 1</p>
  </body>
</html>
```

---

### 5.2 Configuración del Contenedor Apache

Archivo **Dockerfile** en `/proyecto/`:

```Dockerfile
# Imagen base
FROM httpd:latest

# Copiar los archivos del sitio web
COPY web/ /usr/local/apache2/htdocs/

# Exponer el puerto 80
EXPOSE 80
```

Construcción de la imagen personalizada:

```bash
sudo docker build -t servidor-grupo1 .
```

Ejecución del contenedor:

```bash
sudo docker run -d -p 8080:80 servidor-grupo1
```

Verificación:

- Acceder desde el navegador a:  
   `http://localhost:8080`
- Consultar logs:
  ```bash
  docker logs $(docker ps -q)
  ```

---

## 6. Comparación y Validación

| Aspecto      | Contenedor Apache (Personalizado) | Servidor Apache Nativo |
| ------------ | --------------------------------- | ---------------------- |
| Portabilidad | Alta (imagen Docker)              | Media                  |
| Aislamiento  | Completo                          | Parcial                |
| Despliegue   | Rápido (un solo comando)          | Manual                 |
| Dependencias | Internas al contenedor            | Instaladas en el host  |

---

## Estructura Final del Proyecto

```
/proyecto
├── datos/
├── web/
│   └── index.html
├── scripts/
│   └── reporte_sistema.sh
├── capturas/
├── Dockerfile
└── README.md
```

---

## Créditos

Integrantes:
**Grupo 1**
**Samuel Timoteo Cortéz Hernández — CH21024**
**Luis Eduardo Molina Cáceres — MC23015**
**José Wilfredo Ponce Barahona — PB24007**
**Ana Estefany Quintanilla de Ponce — QP24002**
Proyecto desarrollado en entorno **Debian + Apache + Docker**  
Asignatura: _Introducción al Software Libre_  
Tutor GT03: _Ing. Francisco Javier Morales Ayala_
_Universidad de El Salvador_
