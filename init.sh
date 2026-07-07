#!/bin/bash
set -e

echo ">>> Iniciando MariaDB..."
service mariadb start

until mysqladmin ping --silent; do
    echo "Esperando a MariaDB..."
    sleep 1
done

mysql <<EOF

CREATE DATABASE IF NOT EXISTS biblioteca;

CREATE USER IF NOT EXISTS 'biblioteca_user'@'%'
IDENTIFIED BY 'secret123';

GRANT ALL PRIVILEGES ON biblioteca.* TO 'biblioteca_user'@'%';

FLUSH PRIVILEGES;

USE biblioteca;

CREATE TABLE IF NOT EXISTS libros(
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150),
    autor VARCHAR(100),
    anio INT
);

INSERT IGNORE INTO libros(id,titulo,autor,anio)
VALUES
(1,'Cien años de soledad','Gabriel García Márquez',1967),
(2,'Don Quijote de la Mancha','Miguel de Cervantes',1605),
(3,'Rayuela','Julio Cortázar',1963),
(4,'La casa de los espíritus','Isabel Allende',1982);

EOF

echo ">>> Iniciando Apache..."
exec apache2-foreground