#!/bin/bash
# 1. Actualizar repositorios
apt update -y

# 2. INSTALAR NODE.JS 20 (Vital para Vite 8 / React moderno)
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs git nginx

# 3. Clonar repositorio (Rama main por defecto)
cd /var/www
rm -rf DevopsCorporation # Limpieza por si acaso
git clone https://github.com/BenjaminArellano/DevopsCorporation.git

# 4. Entrar a la subcarpeta del frontend
cd DevopsCorporation/frontend

# 5. Instalar dependencias y generar el Build de producción
# Usamos --unsafe-perm para evitar problemas de permisos con carpetas de root
npm install
npm run build

# 6. Configurar Nginx como Reverse Proxy
# Mantenemos tu bloque EOF, pero aseguramos la ruta correcta
cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80;

    # Sirve los archivos de React desde la carpeta estándar de Ubuntu
    location / {
        root /var/www/html;
        index index.html;
        try_files \$uri \$uri/ /index.html;
    }

    # Redirige el tráfico /api al Backend usando la IP privada
    location /api/ {
        proxy_pass http://${back_ip}:8080/api/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

# 7. Mover el build a la ruta que configuramos en Nginx
# Borramos lo que haya en /var/www/html y movemos el contenido de dist/
rm -rf /var/www/html/*
cp -r dist/* /var/www/html/

# 8. CORRECCIÓN DE PERMISOS (Para evitar el 403 Forbidden)
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# 9. Iniciar y reiniciar nginx para aplicar los cambios
systemctl enable nginx
systemctl restart nginx