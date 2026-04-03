#!/bin/bash

# 1. Actualizar e instalar Java 21 (Como root)
sudo apt update -y
sudo apt install -y openjdk-21-jdk git curl

# 2. Limpiar instalaciones previas si existen (Evita el error de permisos)
sudo rm -rf /home/ubuntu/DevopsCorporation
sudo rm -f /home/ubuntu/app.log

# 3. Clonar proyecto como el usuario ubuntu (MUY IMPORTANTE)
# Esto evita que los archivos pertenezcan a root
cd /home/ubuntu
git clone https://github.com/BenjaminArellano/DevopsCorporation.git
sudo chown -R ubuntu:ubuntu /home/ubuntu/DevopsCorporation

# 4. Entrar al Backend
cd /home/ubuntu/DevopsCorporation/backend

# 5. Crear el archivo de propiedades
mkdir -p src/main/resources
cat <<EOF > src/main/resources/application.properties
spring.application.name=backend
spring.datasource.url=jdbc:mysql://${db_ip}:3306/empdb
spring.datasource.username=Admin
spring.datasource.password=Admin
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.database-platform=org.hibernate.dialect.MySQLDialect
server.port=8080
EOF

# 6. Preparar ejecución
chmod +x mvnw

# 7. Esperar a la Base de Datos (Reducido a 60s, 240s es demasiado)
echo "Esperando a que la base de datos este lista..."
sleep 60

# 8. Ejecutar con CLEAN y como usuario ubuntu
# Usamos 'sudo -u ubuntu' para asegurar que el log sea escribible por el usuario
sudo -u ubuntu nohup ./mvnw clean spring-boot:run > /home/ubuntu/app.log 2>&1 &

echo "Despliegue finalizado. Revisa el log con: tail -f /home/ubuntu/app.log"