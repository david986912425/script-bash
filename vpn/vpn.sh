#!/bin/bash

# Cambiar al directorio especificado
cd /home/david/Escritorio/vpn || { echo "No se puede cambiar al directorio"; exit 1; }

# Listar los archivos .ovpn
archivos=( *.ovpn )

# Verificar si hay archivos .ovpn en el directorio
if [ ${#archivos[@]} -eq 0 ]; then
    echo "No se encontraron archivos .ovpn en el directorio."
    exit 1
fi

archivo=$(printf '%s\n' "${archivos[@]}" | fzf --height 1% --border)

# Verificar si se ha seleccionado un archivo
if [ -n "$archivo" ]; then
    sudo openvpn "$archivo"
else
    echo "Selección no válida o ningún archivo seleccionado."
    exit 1
fi
