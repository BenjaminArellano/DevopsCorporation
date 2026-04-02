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

# Permisos Maven wrapper
chmod +x mvnw

# Esperar un poco por la DB (muy importante)
sleep 30

# Ejecutar backend en segundo plano
nohup ./mvnw spring-boot:run > app.log 2>&1 &