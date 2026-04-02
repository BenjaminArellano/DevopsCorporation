#!/bin/bash
apt update -y

# Instalar herramientas base
apt install -y git wget tar curl

# Descargar OpenJDK 25 (Temurin)
cd /opt
wget https://github.com/adoptium/temurin25-binaries/releases/latest/download/OpenJDK25U-jdk_x64_linux_hotspot.tar.gz

# Extraer
tar -xzf OpenJDK25U-jdk_x64_linux_hotspot.tar.gz

# Detectar carpeta
JAVA_DIR=$(ls -d jdk-25*)

# Configurar entorno global
echo "export JAVA_HOME=/opt/$JAVA_DIR" > /etc/profile.d/java.sh
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile.d/java.sh

# Aplicar variables
export JAVA_HOME=/opt/$JAVA_DIR
export PATH=$JAVA_HOME/bin:$PATH

# Verificar Java
java -version

# Clonar proyecto
cd /home/ubuntu
git clone https://github.com/BenjaminArellano/DevopsCorporation.git

cd DevopsCorporation

# 1. AGREGAR ESTO: Entrar a la subcarpeta del backend
cd backend 

# 2. AGREGAR ESTE BLOQUE: Crear el properties con la IP inyectada
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

# Permisos Maven wrapper
chmod +x mvnw

# Esperar un poco por la DB (muy importante)
sleep 30

# Ejecutar backend en segundo plano
nohup ./mvnw spring-boot:run > app.log 2>&1 &