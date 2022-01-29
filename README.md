# docker_homework

# 1 Лекция
Написать Dockerfile для frontend располагается в директории /frontend, собрать и запустить

## Решение

```bash
cd <repo name>/frontend
```

Создаём `Dockerfile`
```bash
cat Dockerfile
```

Собираем и запускаем контейнер
```bash
docker build -t nodejs:v0.1 . \
  && docker run --rm -p 3000:80 -d nodejs:v0.1
```

# 2 Лекция
Написать Dockerfile для backend который располагается в директории /lib_catalog(для сборки контейнера необходимо использовать файл /lib_catalog/requirements.txt), для работы backend необходим postgresql, т.е. необходимо собрать 2 контейнера:
1. backend
2. postgresql

Осуществить сетевые настройки, для работы связки backend и postgresql

## Решение

```bash
cd <repo name>/lib_catalog
```

Создаём сеть
```bash
docker network create task2
```

Запускаем контейнер с базой данных
```bash
docker run --name database \
           --network task2 --rm -it \
       -e POSTGRES_DB=django \
       -e POSTGRES_USER=django \
       -e POSTGRES_PASSWORD=django \
       -d postgres:12-alpine3.15
```

Устанавливаем переменные в файле .env
```bash
mv env_example .env
cat .env
```

Собираем и запускаем контейнер с `backend`
```bash
docker build -t python . \
  && docker run --name backend -p8000:8000 \
  --rm --network task2 -d python
```

# 3 Лекция
Написать docker-compose.yaml, для всего проекта, собрать и запустить

## Решение

```bash
cd <repo name>
```

Запускаем registry
```bash
docker-compose -f docker-compose-registry.yml up -d
```

Устанавливаем переменные в файле .env
```bash
mv lib_catalog/env_example lib_catalog/.env
cat lib_catalog/.env
```

Собираем образы
```bash
docker-compose -f docker-compose-build.yml build
```

Запускаем контейнеры
```bash
docker-compose -f docker-compose-up.yml up -d
```

Очистим всё
```bash
docker-compose -f docker-compose-up.yml down \
  && docker-compose -f docker-compose-registry.yml down \
  && docker system prune -a -f \
  && docker volume prune -f
```

Запустим проект со сборкой
```bash
docker-compose -f docker-compose-build-and-start.yml up -d
```

# Критерий оценки финального задания
1. Dockerfile должны быть написаны согласно пройденным best practices
2. Для docker-compose необходимо использовать локальное image registry
3. В docker-compose необходимо сетевые настройки 2 разных интерфейса(bridge), 1 - для фронта, 2 - для бека с postgresql

4.* Осущиствить сборку проекта самим docker-compose команда docker-compose build(при использовании этого подхода необходимо исключить 2 пункт из критерии оценки)
