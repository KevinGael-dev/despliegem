# Imagen base: PHP 8.2 con Apache incluido
FROM php:8.2-apache

# Instalar MySQL Server y la extensión mysqli para PHP
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y default-mysql-server && \
    docker-php-ext-install mysqli && \
    rm -rf /var/lib/apt/lists/*

# Copiar el código de la aplicación al directorio público de Apache
COPY app/ /var/www/html/

# Copiar el script de inicialización
COPY init.sh /init.sh
RUN chmod +x /init.sh

# Ajustar permisos del directorio de datos de MySQL
RUN mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld /var/lib/mysql

EXPOSE 80

# El contenedor arranca MySQL y luego Apache en primer plano
CMD ["/init.sh"]
