FROM php:7.3-apache

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    build-essential \
    locales \
    git \
    unzip \
    zip \
    curl

# Activamos Apache Rewrite
RUN a2enmod rewrite

# Instalar extensiones de PHP
RUN docker-php-ext-install mysqli pdo_mysql mbstring

# Instalar composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Descargar proyecto web
RUN git clone https://github.com/Azure-Samples/laravel-tasks /var/www/html

#Copiamos las variables de entorno del proyecto
COPY .env /var/www/html

#Instalamos dependencias de Laravel
RUN composer install --working-dir /var/www/html

#Generamos claves del proyecto Laravel
RUN php /var/www/html/artisan key:generate

#Ejecutamos las migraciones (ESTO MEJOR HACERLO POR LINEA DE COMANDOS LA PRIMERA VEZ)
##RUN php /var/www/html/artisan migrate

#Damos permisos a la carpeta desplegada
RUN chown -R www-data:www-data /var/www/html