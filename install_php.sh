#!/bin/bash

PHP_VERSION=$(php -v 2>/dev/null | grep -o "PHP 8.1")

if [ "$PHP_VERSION" == "PHP 8.1" ]; then
    echo "PHP 8.1 ya está instalado."
else
    echo "PHP 8.1 no está instalado. Iniciando proceso de instalación..."
    sudo apt update
    sudo apt upgrade -y
    sudo apt install software-properties-common ca-certificates lsb-release apt-transport-https -y

    sudo add-apt-repository ppa:ondrej/php -y

    sudo apt update

    sudo apt install php8.1 -y
    sudo apt install php8.1-cli php8.1-fpm php8.1-mysql php8.1-xml php8.1-mbstring php8.1-curl php8.1-zip php8.1-gd -y

    echo "PHP 8.1 y las extensiones comunes se han instalado correctamente."
fi
