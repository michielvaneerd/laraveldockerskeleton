# Steps to create and run a development Larevel Docker image

This Docker project is used only for development: it has only 1 .env file and username and password are included so *not secure*.

It removes the vendor directory from the volume mount due to bad performance on the Mac (and maybe Windows?).
This means that if you want the vendor directory in subversion, you need to copy it from the container to the
each time this directory is changed.

## 1. Create directory structure like in this project

- /docker
- /docker/init
- /docker/init/apache.sh
- /docker/Dockerfile
- /docker-compose.yml
- /htdocs

See the *docker-compose.yml*, *Dockerfile* and *apache.sh* files. Make sure you update the names
of the image and volumes in the *docker-compose.yml* file.

## 2. Download the appropriate Laravel release

Download it from: https://github.com/laravel/laravel/releases and unzip it
into the htdocs directory.

**Make sure to copy the .env.example to .env and update it with the appropriate values, like
database values, APP_URL and the APP_DEV_ADMIN_USER keys!**
- DB_HOST sould be mysql instead of localhost or 127.0.0.1

## 3. Build the image

You have to do this only once.

`docker-compose build`

## 4. Build and run container

`docker-compose up`

## 5. Stop and remove container

`docker-compose down`

## 6. Other commands that you should run only once

If you want to add the admin user (specified in .env.example file), bash into the container and do once:

`php artisan db:seed`

## 7. Other useful commands

See all volumes:

`docker volume ls`

Remove a volume:

`docker volume rm [ID]`

See all images:

`docker image ls`

Remove an image:

`docker image rm [ID]`

See all containers:

`docker ps -a`

Remove a container:

`docker comtainer rm [ID]`

Bash into a container:

`docker exec -it [ID] bash`