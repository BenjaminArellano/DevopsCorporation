#!/bin/bash
# 1. Actualizar e instalar Java 21 (El estándar actual)
apt update -y
apt install -y openjdk-21-jdk git curl

# 2. Configurar variables de entorno automáticamente
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# 3. Clonar proyecto
cd /home/ubuntu
rm -rf DevopsCorporation
git clone https://github.com/BenjaminArellano/DevopsCorporation.git

# 4. Configurar el Backend
cd DevopsCorporation/backend 

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

# 6. Permisos y ejecución
chmod +x mvnw
sleep 240

# 7. Ejecutar y guardar log en sitio seguro
nohup ./mvnw spring-boot:run > /home/ubuntu/app.log 2>&1 &