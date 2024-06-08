#!/bin/bash

# Comprobar si se proporcionó un parámetro de correo electrónico
if [ -z "$1" ]; then
    echo "Uso: $0 <email>"
    exit 1
fi

# Variables
EMAIL="$1"

# Paso 1: Generar una clave SSH si no existe
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Generando una nueva clave SSH..."
    ssh-keygen -t rsa -b 4096 -C "$EMAIL" -N "" -f ~/.ssh/id_rsa
    echo "Clave SSH generada."
else
    echo "Ya existe una clave SSH en ~/.ssh/id_rsa."
fi

# Paso 2: Iniciar el agente SSH y añadir la clave
echo "Iniciando el agente SSH..."
eval "$(ssh-agent -s)"

echo "Añadiendo la clave SSH al agente..."
ssh-add ~/.ssh/id_rsa

# Paso 3: Mostrar la clave pública y copiarla al portapapeles
echo "Clave pública SSH:"
cat ~/.ssh/id_rsa.pub

# Nota: El usuario debe añadir manualmente esta clave a su cuenta de GitHub/GitLab/Bitbucket
echo "Por favor, añade la clave pública mostrada arriba a tu cuenta de Git (GitHub/GitLab/Bitbucket)."

# Paso 4: Probar la conexión SSH (por ejemplo, a GitHub)
read -p "Presiona [Enter] después de haber añadido la clave a tu cuenta de Git para probar la conexión SSH..."

echo "Probando la conexión SSH a GitHub..."
ssh -T git@github.com

echo "Proceso completado."
