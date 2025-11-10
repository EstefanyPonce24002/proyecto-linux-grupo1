#!/bin/bash
# --------------------------------------------------------
# Script: reporte_sistema.sh
# Descripción: Muestra información del sistema y Docker
# --------------------------------------------------------

# 1. Fecha y hora actual
echo "========================="
echo "📅 Fecha y hora: $(date)"
echo "========================="

# 2. Nombre del host
echo "🖥️ Hostname: $(hostname)"

# 3. Número de usuarios conectados
echo "👥 Usuarios conectados: $(who | wc -l)"

# 4. Espacio libre en el disco principal
echo "💾 Espacio libre en disco (raíz):"
df -h / | awk 'NR==2 {print $4 " libres de " $2}'

# 5. Memoria RAM disponible
echo "🧠 Memoria disponible:"
free -h | awk '/Mem:/ {print $7 " libres de " $2}'

# 6. Número de contenedores Docker activos
if command -v docker &> /dev/null; then
    activos=$(docker ps -q | wc -l)
    echo "🐳 Contenedores Docker activos: $activos"
else
    echo "🐳 Docker no está instalado o no está en ejecución."
fi

echo "========================="
echo ""
