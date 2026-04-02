#!/bin/bash
apt update -y

# Instalar Node
apt install -y nodejs npm git nginx

# Clonar repo
cd /var/www
git clone https://github.com/BenjaminArellano/DevopsCorporation.git

cd DevopsCorporation

# Instalar dependencias
npm install

# Build de producción
npm run build

# Mover build a nginx
rm -rf /var/www/html/*
cp -r dist/* /var/www/html/

# Iniciar nginx
systemctl start nginx
systemctl enable nginx