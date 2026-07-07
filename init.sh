#!/bin/bash
set -e

echo ">>> Iniciando servicio MySQL..."
echo "=== Servicios disponibles ==="
ls -l /etc/init.d || true

echo "=== Buscando mysqld ==="
which mysqld || true

echo "=== Buscando mariadbd ==="
which mariadbd || true

echo "=== Buscando mysql ==="
which mysql || true
echo ">>> Iniciando servicio de base de datos..."

if [ -f /etc/init.d/mariadb ]; then
    service mariadb start
elif [ -f /etc/init.d/mysql ]; then
    service mysql start
else
    echo "No se encontró el servicio MariaDB/MySQL"
    exit 1
fi

# Esperar a que MySQL esté listo para aceptar conexiones
until mysqladmin ping -h "localhost" --silent; do
    echo "Esperando a MySQL..."
    sleep 1
done

echo ">>> Configurando base de datos 'biblioteca'..."
mysql -u root <<-EOSQL
    ALTER USER 'root'@'localhost' IDENTIFIED BY 'root_password';
    CREATE DATABASE IF NOT EXISTS biblioteca;
    USE biblioteca;
    CREATE TABLE IF NOT EXISTS libros (
        id INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(150) NOT NULL,
        autor VARCHAR(100) NOT NULL,
        anio INT
    );
    INSERT INTO libros (titulo, autor, anio)
    SELECT * FROM (SELECT 'Cien años de soledad', 'Gabriel García Márquez', 1967) AS tmp
    WHERE NOT EXISTS (SELECT 1 FROM libros WHERE titulo = 'Cien años de soledad') LIMIT 1;

    INSERT INTO libros (titulo, autor, anio)
    SELECT * FROM (SELECT 'Don Quijote de la Mancha', 'Miguel de Cervantes', 1605) AS tmp
    WHERE NOT EXISTS (SELECT 1 FROM libros WHERE titulo = 'Don Quijote de la Mancha') LIMIT 1;

    INSERT INTO libros (titulo, autor, anio)
    SELECT * FROM (SELECT 'Rayuela', 'Julio Cortázar', 1963) AS tmp
    WHERE NOT EXISTS (SELECT 1 FROM libros WHERE titulo = 'Rayuela') LIMIT 1;

    INSERT INTO libros (titulo, autor, anio)
    SELECT * FROM (SELECT 'La casa de los espíritus', 'Isabel Allende', 1982) AS tmp
    WHERE NOT EXISTS (SELECT 1 FROM libros WHERE titulo = 'La casa de los espíritus') LIMIT 1;
EOSQL

echo ">>> Base de datos lista."
echo ">>> Iniciando Apache en primer plano..."
apache2-foreground
