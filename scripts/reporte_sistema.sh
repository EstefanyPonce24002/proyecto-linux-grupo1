#!/bin/bash

echo "==== REPORTE DEL SISTEMA ===="
echo "Fecha y hora: $(date)"
echo "Hostname: $(hostname)"
echo "Usuarios conectados: $(who | wc -l)"
echo "Espacio libre en disco (/): $(df -h / | awk 'NR==2 {print $4}')"
echo "Memoria RAM disponible: $(free -h | awk '/Mem:/ {print $7}')"
echo "Contenedores Docker activos: $(docker ps -q | wc -l)"
echo "=============================="
#ponce#
