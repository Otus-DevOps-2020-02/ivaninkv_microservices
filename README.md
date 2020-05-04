# ivaninkv microservices repository

## HW12 Docker под капотом

**Основное ДЗ**

* Настроили интеграцию с `travis-ci`
* Установили `docker` и `docker-machine`
* Проверили базовые команды `docker`
    * docker run (create + start + attach)
    * docker start
    * docker attach
    * docker exec
    * docker kill
    * docker stop
    * docker rm
    * docker rmi
* Создали image из запущенного контейнера (`docker commit`)
* Создали docker-host на GCP
* Созздали свой образ при помощи `Dockerfile` и `docker build`
* Запустили контейнер в docker-host на GCP
* Опубликовали образ на [dockerhub](https://hub.docker.com/r/const84/otus-reddit)

Команда создания docker-host'а:
```
docker-machine create --driver google \
    --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
    --google-machine-type n1-standard-1 \
    --google-zone europe-west1-b \
    docker-host
```

Команда создания правила файервола:
```
 gcloud compute firewall-rules create reddit-app \
    --allow tcp:9292 \
    --target-tags=docker-machine \
    --description="Allow PUMA connections" \
    --direction=INGRESS
```

**Первое задание со***

* Описали различия в выводе команд `docker inspect container` и `docker inspect image` в файле `docker-1/log`

**Второе задание со***

* Описали создание инстансов с помощью `terraform`
* Описали плейбуки ansible для установки `docker`
* Описали файлы для создания образов с установленным `docker`'ом

## HW13 Docker. Микросервисы

**Основное ДЗ**

* Скачали исходники приложения
* Установили [hadolint](https://github.com/hadolint/hadolint) и плагин для VS Code
* Создали 3 докерфайла для различных компонентов сервиса
* Собрали 3 образа, при сброке образа `ui`, использовался кэш
* Создали bridge network для контейнеров, запустили их и проверили работоспособность сервиса
* Пересоздали образ ui исользуя другой базовый образ, чтобы уменьшить размер образа
* Подключили `docker volume` для сохранения данных после перезапуска контейнеров.

**Первое задание со***

Оригинальная команда запуска:
```
docker network create reddit
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
docker run -d --network=reddit --network-alias=post const84/post:1.0
docker run -d --network=reddit --network-alias=comment const84/comment:1.0
docker run -d --network=reddit -p 9292:9292 const84/ui:2.0
```

Команда с передачей ENV, документация по [ссылке](https://docs.docker.com/engine/reference/commandline/run/#set-environment-variables--e---env---env-file):
```
docker run -d --network=reddit --network-alias=post_db1 --network-alias=comment_db1 mongo:latest
docker run -d --network=reddit \
            --env POST_DATABASE_HOST=post_db1 \
            --env POST_DATABASE=posts1 \
            --network-alias=post1 const84/post:1.0
docker run -d --network=reddit \
            --env COMMENT_DATABASE_HOST=comment_db1 \
            --env COMMENT_DATABASE=comments1 \
            --network-alias=comment1 const84/comment:1.0
docker run -d --network=reddit \
            --env POST_SERVICE_HOST=post1 \
            --env COMMENT_SERVICE_HOST=comment1 \
            -p 9292:9292 const84/ui:2.0
```

**Второе задание со***

Не получилось полностью выполнить, было лень разбираться с `ruby` и его зависимостями. Пример докерфайла можно посмотреть [здесь](https://github.com/andrius/alpine-ruby/blob/master/Dockerfile-latest).

## HW14 Сеть Docker. Docker-compose

**Основное ДЗ**
