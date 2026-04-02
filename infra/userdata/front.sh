#!/bin/bash
apt update -y

# Instalar Node
apt install -y nodejs npm git nginx

# Clonar repo
cd /var/www
git clone https://github.com/BenjaminArellano/DevopsCorporation.git

cd DevopsCorporation

# 1. AGREGAR ESTO: Entrar a la subcarpeta del frontend
cd frontend

# 2. AGREGAR ESTE BLOQUE: Configurar Nginx como Reverse Proxy
cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80;

    # Sirve los archivos de React
    location / {
        root /var/www/html;
        index index.html;
        try_files \$uri \$uri/ /index.html;
    }

    # Redirige el tráfico /api al Backend
    location /api/ {
        proxy_pass http://${back_ip}:8080/api/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

# Instalar dependencias
npm install

# Build de producción
npm run build

# Mover build a nginx
rm -rf /var/www/html/*
cp -r dist/* /var/www/html/

# Iniciar y reiniciar nginx para aplicar los cambios
systemctl start nginx
systemctl enable nginx
systemctl restart nginx