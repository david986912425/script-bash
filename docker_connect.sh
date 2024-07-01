#!/bin/bash

instanciaName=$(docker ps --format "{{.Names}}" | tail -n+1 | fzf --height 40% --border)

if [ -z "$instanciaName" ]; then
    echo "No se seleccionó ningún contenedor."
    exit 1
fi

docker exec -it "$instanciaName" bash

if [ $? -ne 0 ]; then
    docker exec -it "$instanciaName" ash
fi