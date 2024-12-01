#!/bin/bash
echo "Deteniendo contenedores..."
docker-compose down

echo "Eliminando volúmenes de node_modules..."
docker volume rm $(docker volume ls -q | grep node_modules) 2>/dev/null || true

echo "Limpiando caché de Docker..."
docker system prune -f

echo "Reconstruyendo contenedores..."
docker-compose build --no-cache

echo "Iniciando servicios..."
docker-compose up -d
