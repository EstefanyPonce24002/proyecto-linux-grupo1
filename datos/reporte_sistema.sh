#!/bin/bash
# ----------------------------------------------
# Script: reporte_sistema.sh
# Descripción: Muestra información básica del sistema
# Autor: Tu nombre / Grupo X


echo "------------------------------------------"
echo "      REPORTE DE ESTADO DEL SISTEMA"
echo "------------------------------------------"
echo ""

# Fecha y hora actual
echo " Fecha y hora actual: $(date '+%Y-%m-%d %H:%M:%S')"

# Nombre del host
echo " Nombre del host: $(hostname)"

# Número de usuarios conectados
echo " Usuarios conectados: $(who | wc -l)"

# Espacio libre en el disco principal (/)
echo " Espacio libre en disco (/): $(df -h / | awk 'NR==2 {print $4}')"

# Memoria RAM disponible
echo "Memoria RAM disponible: $(free -h | awk '/Mem:/ {print $7}')"

# Número de contenedores Docker activos
if command -v docker &> /dev/null; then
    activos=$(sudo docker ps -q | wc -l)
    echo " Contenedores Docker activos: $activos"
else
    echo " Docker no está instalado o no se encuentra en el sistema."
fi

echo ""
echo "-----------------------------------------"
echo "Fin del reporte."
echo "------------------------------------------"

