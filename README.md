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
export GOOGLE_PROJECT=docker-275604

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

* Поэксперементировали с сетями и алиасами сетей
* Создали 2 сети и запустили в них наше приложение
* Посмотрели создаваемые правила файервола
* Запустили базовый `docker-compose` файл
* Параметризировали `docker-compose` с помощью [`.env`](https://docs.docker.com/compose/environment-variables/#the-env-file) файла
* Имя проекта `docker-compose` можно задать с помощью опции командной строки [`-p`](https://docs.docker.com/compose/reference/overview/) или с помощью переменной окружения [`COMPOSE_PROJECT_NAME`](https://docs.docker.com/compose/reference/envvars/#compose_project_name).

**Задание со***

* Написан файл `docker-compose.override.yml`
    * ui, comment запускаются командой `puma --debug -w 2`
    * post запускается командой с помощью нового скрипта `new_post_app.py` (который является копией оригинального)
* Продвинутое конфигурирование [docker-compose](https://habr.com/ru/company/otus/blog/337688/)

## HW15 Gitlab CI

**Основное ДЗ**

* Подняли машину с докером в GCP
* Установили туда Gitlab CI, gitlab-runner
* Создали группу проектов, проект
* Создали пайплайн и зарегистрировали его
* Добавили исходный код приложения в репозиторий
* Добавили тест для приложения
* Описали несколько окружений
* stage и prod окружения запускаются только тогда, когда проставлен тэг в гите
* Добавили динамические окружения

**Задание со***

* Как делать билд контейнеров докер в GitLab описано в [документации](https://docs.gitlab.com/ee/ci/docker/using_docker_build.html). Плюс есть пример в файле к лекции MeetUP.pdf
* Для автоматизации установки `gitlab-runner` можно использовать готовые `ansible` роли, как например [эта](https://github.com/riemers/ansible-gitlab-runner)
* Настроена интеграция со [slack](https://devops-team-otus.slack.com/archives/CV8CVA69E)

## HW16 Monitoring

**Основное ДЗ**

* Создали DockerHost и подняли в нем Prometheus
* Изучили web-интерфейс Prometheus
* Создали свой docker-образ Prometheus со своим конфигом
* Создали `docker-compose.yml` с микросервисами и Prometheus'ом
* Проверили как работает мониторинг, если останавливать один из компонентов системы
* Добавили `node-exporter` в нашу конфигурацию, для мониторинга состояния хоста
* Сслыка на [DockerHub](https://hub.docker.com/u/const84)

**Задание со***

* [Mongo-exporter](https://hub.docker.com/r/bitnami/mongodb-exporter)
* [Blackbox-exporter](https://github.com/prometheus/blackbox_exporter)
* Документация по make
    * [раз](https://www.ibm.com/developerworks/ru/library/l-debugmake/index.html)
    * [два](https://habr.com/ru/post/132524/)
    * [три](http://rus-linux.net/nlib.php?name=/MyLDP/algol/gnu_make/gnu_make_3-79_russian_manual.html)


## HW17 Monitoring 2. Приложение и инфраструктура

**Основное ДЗ**

* Разделили файл `docker-compose.yml` на 2, отдельно приложение и отдельно мониторинг
* Добавили [cAdviser](https://github.com/google/cadvisor) для мониторинга Docker контейнеров
* Добавили `Grafana` для визуализации данных `Prometheus`
* Настроили несколько дашбордов, визуализирующих как технические, так и бизнес метрики
* Настроили алертинг при недоступности одного из сервисов в течении 1 минуты
* Сслыка на [DockerHub](https://hub.docker.com/u/const84)


## HW18 Логирование в инфраструктуре Docker

**Основное ДЗ**

* Создали Docker-compose для централизованного логирования (ElasticSearch, Fluentd, Kibana)
* При запуске инфоаструктуры логирования встретились 2 ошибки
    * `max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]` - решение [тут](https://github.com/elastic/elasticsearch-docker/issues/92#issuecomment-318086404)
    * `the default discovery settings are unsuitable for production use; at least one of [discovery.seed_hosts, discovery.seed_providers, cluster.initial_master_nodes] must be configured` - решение добавить в docker-compose-logging девелопер-режим
    ```
        environment:
            - discovery.type=single-node
    ```

* Добавили в сервис post драйвер `fluentd` для логирования структурированных логов
* Добавили в сервис ui драйвер `fluentd` для логирования неструктурированных логов
* В интерфейсе `Kibana` настроили индекс для просмотра логов
* Посмотрели как `Kibana` отображет логи, попробовали как работает поиск
* В `ﬂuent.conf` настроили парсер, для парсинга `json` по полям
* Для несруктурированных логов настроили и проверили парсинг логов через регулярку и grok-шаблон
* Добавили в инфраструктуру `zipkin` и проверили распределенную трассировку

## HW19 Kubernetes. The Hard Way

[Инструкция](https://github.com/kelseyhightower/kubernetes-the-hard-way)

**Основное ДЗ**

* Пререквизиты - установили `gcloud` и выполнили аутентификацию, установили дефолтную зону и регион
* Установили клиентские утилиты [cfssl](https://github.com/cloudflare/cfssl), [cfssljson](https://github.com/cloudflare/cfssl), and [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
* Создали VPC для кластера k8s, правила фаервола, внешний IP. Создали 3 контроллера и 3 воркера.
* С помощью утилиты `cfssl` сгенерировали сертификат и приватный ключ для авторизации, для каждого воркера, для контроллера, прокси и шедуллера, API-сервера.
* Сгенерировали конфигурационные файлы для воркеров, kube-proxy, controller-manager, kube-scheduler
* Сгенерировали ключ и конфиг шифрования, залили их на контроллеры
* Сконфигурировали и запустили `etcd` на контроллерах
* Настроили и запустили на контроллерах `kube-apiserver`, `kube-controller-manager`, `kube-scheduler`, `kubectl`
* Установили и запустили на воркерах `runc`, `container networking plugins`, `containerd`, `kubelet`, `kube-proxy`
* Сгенерировали `kubeconfig`
* Настроили правила маршрутизации
* Установили `DNS add-on` для k8s
* Создали Deployment `nginx` и протестировали port-forwarding, просмотр логов, выполнение команд на подах
* Выполнили команду `kubectl apply -f post-deployment.yml` для проверки работоспособности кластера с нашим приложением
