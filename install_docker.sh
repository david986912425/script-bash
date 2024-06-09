#!/bin/bash

# Función para instalar Docker
install_docker() {
  # Actualizar el índice de paquetes
  sudo apt-get update

  # Instalar certificados y herramientas necesarias
  sudo apt-get install -y ca-certificates curl gnupg

  # Crear el directorio para las claves GPG
  sudo install -m 0755 -d /etc/apt/keyrings

  # Agregar la clave GPG oficial de Docker
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  # Agregar el repositorio de Docker a las fuentes de Apt
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  # Actualizar el índice de paquetes nuevamente
  sudo apt-get update

  # Instalar Docker y Docker Compose
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

# Verificar si Docker ya está instalado
if command -v docker &> /dev/null; then
  echo "Docker ya está instalado. Omitiendo la instalación."
else
  echo "Docker no está instalado. Procediendo con la instalación."
  install_docker
fi

# Verificar las versiones instaladas
docker --version
docker compose version
