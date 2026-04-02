#!/bin/bash
apt update -y

# Instalar MySQL
apt install -y mysql-server

systemctl start mysql
systemctl enable mysql

# Configuración inicial
mysql -e "CREATE DATABASE empdb;"
mysql -e "CREATE USER 'Admin'@'%' IDENTIFIED BY 'Admin';"
mysql -e "GRANT ALL PRIVILEGES ON empdb.* TO 'Admin'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# Permitir conexiones remotas
sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

systemctl restart mysql