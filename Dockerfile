# Usar la imagen oficial de Nginx como base
FROM nginx:latest

# Copiar todo el contenido del directorio web/ al directorio de Nginx
COPY web/ /usr/share/nginx/html/

# Exponer el puerto 80
EXPOSE 80

# Comando por defecto para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]
