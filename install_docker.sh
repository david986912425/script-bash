#!/bin/bash

# Función para instalar Docker
install_docker() {
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl gnupg
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update

  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

if command -v docker &> /dev/null; then
  echo "Docker ya está instalado. Omitiendo la instalación."
else
  echo "Docker no está instalado. Procediendo con la instalación."
  install_docker
fi


if groups $USER | grep &>/dev/null '\bdocker\b'; then
  echo "El usuario $USER ya está en el grupo docker."
else
  sudo usermod -a -G docker $USER
  echo "El usuario $USER ha sido agregado al grupo docker."
fi

docker --version
docker compose version
