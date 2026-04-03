#!/bin/bash
apt update -y

# 1. Instalar MySQL
apt install -y mysql-server
systemctl start mysql
systemctl enable mysql

# 2. Configuración de base de datos y usuario
# Usamos "IF NOT EXISTS" para que el script sea seguro de ejecutar varias veces
mysql -e "CREATE DATABASE IF NOT EXISTS empdb;"
mysql -e "CREATE USER IF NOT EXISTS 'Admin'@'%' IDENTIFIED BY 'Admin';"
mysql -e "GRANT ALL PRIVILEGES ON empdb.* TO 'Admin'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# 3. CREAR TABLA E INSERTAR DATOS (Esto es lo que pediste)
# Importante: El nombre de la tabla y columnas debe coincidir con tu entidad Java
mysql -D empdb -e "
CREATE TABLE IF NOT EXISTS empleado (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255),
    cargo VARCHAR(255)
);

INSERT INTO empleado (nombre, cargo) VALUES ('Benjamin Arellano', 'DevOps Engineer');
INSERT INTO empleado (nombre, cargo) VALUES ('Jose Penaloza', 'Fullstack Developer');
INSERT INTO empleado (nombre, cargo) VALUES ('Pancho Hernandez', 'Database Administrator');
INSERT INTO empleado (nombre, cargo) VALUES ('Teacher Castillo', 'Orden Administrator');
INSERT INTO empleado (nombre, cargo) VALUES ('Scarleth Perez', 'CEO');
INSERT INTO empleado (nombre, cargo) VALUES ('Rodrigo Berrios', 'Devops Engineer suplente del suplente');
"

# 4. Permitir conexiones remotas (Indispensable para que el Backend se conecte)
sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# 5. Reiniciar para aplicar cambios
systemctl restart mysql