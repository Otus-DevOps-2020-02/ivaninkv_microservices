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

**Второе задание с***

* Описали создание инстансов с помощью `terraform`
* Описали плейбуки ansible для установки `docker`
* Описали файлы для создания образов с установленным `docker`'ом
