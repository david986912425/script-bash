#!/bin/bash

setup_idbi() {
  mkdir -p ~/idbi && cd ~/idbi || exit
}

clone_repositories() {
  git clone git@github.com:idbi/id-pos.git
  git clone git@github.com:idbi/id-backend.git
  git clone git@github.com:idbi/id-laradock.git
}

update_backend() {
  cd ~/idbi/id-backend || exit
  git pull && git checkout production
  wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1uWv1IxXni2khq-pCy6s8VXefb7meZAqs' -O 'vendor.zip'
  unzip vendor.zip
  rm vendor.zip
}

clone_laradock() {
  cd ~/idbi/id-laradock || exit
  git pull && git checkout lite
}

load_docker_images() {
  bash <(curl -s https://raw.githubusercontent.com/david986912425/script-bash/main/images_docker.sh)
  cd ~/imagesDocker || exit
  docker load -i idbi-php-fpm.tar
  docker load -i idbi-mariadb.tar
  docker load -i idbi-nginx.tar
  docker load -i idbi-redis.tar
  docker load -i idbi-workspace.tar
}

create_database() {
  mkdir -p ~/idbi/bk && cd ~/idbi/bk
  wget --header="Host: drive.usercontent.google.com" --header="User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36" --header="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8" --header="Accept-Language: es-ES,es;q=0.9" --header="Cookie: AEC=AVYB7coAJScLS7ynv4cE4IDg2Lhxfl0qQqH0Pz7Pvy0pBLa8BPe97agFGA; SOCS=CAISNQgQEitib3FfaWRlbnRpdHlmcm9udGVuZHVpc2VydmVyXzIwMjQwNTE0LjA2X3AwGgJmaSADGgYIgOu0sgY; NID=517=iyMoOO0Nm0zziZ3dDphXuszXzdWiwu4S8fYTU-I1wOufTQfoEEGd0JI4zezD0os5irajaVeYrZzEw-cB0rtUBQER8YcIfS9--sVOlrsqS5_38BkW8ZLA_SLm_Wla-CjS7u4ZkC5bfYqxG4bsYHfgSTS8kGFioXryqDz2hlCp89q2q3ueLHvSVYbyBBGAAnhHud3H26InxCEtKYrKhOjiH87qkGfXZIqQ6g" --header="Connection: keep-alive" "https://drive.usercontent.google.com/download?id=1GcS-Tsq3Sv9fHFl44bn2DXIvz7Y5TIrY&export=download&confirm=t&uuid=f2b30978-79e5-428d-9f8b-7c9c71132358" -c -O '2024-09-23_id_pos.sql.gz'
  gunzip ~/idbi/bk/2024-09-23_id_pos.sql.gz && rm ~/idbi/bk/2024-09-23_id_pos.sql.gz

  docker exec -i idbi-mariadb-1 mysql -u root -p4oYwDkVNXv9cQlzEZ86b -e "CREATE DATABASE IF NOT EXISTS id_pos;"
  docker exec -i idbi-mariadb-1 mysql -u root -p4oYwDkVNXv9cQlzEZ86b id_pos < ~/idbi/bk/2024-09-23_id_pos.sql
}

install_php(){
  bash <(curl -s https://raw.githubusercontent.com/david986912425/script-bash/refs/heads/main/install_php.sh)
}

start_laradock() {
  cd ~/idbi/id-laradock || exit
  docker-compose up
}

main() {
    setup_idbi
    clone_repositories
    update_backend
    clone_laradock
    load_docker_images
    create_database
    start_laradock
}

main
