# Theory-actions 




#### Основные команды GitHub-Actions

- Ветка для отслеживания

```yml
on: 
  push:
    branches:
      - main
```

- ENV переменные 

```yml
env: 
  NODE_ENV: production
  GH_SECRET: 123456789
```

- Добавление секретных ключей из Secret/Actions 

```
echo "${{ secrets.DEPLOY }}"
```


- Отслеживание отпределенной jobs

```yml
needs: test_react_app
```

- Игнорировать actions при изменении определенных директрий

```yml
path-ignore:
  - '.github/workflows/*'
```

#### Подготовка проекта

![](https://github.com/ilinaro/Action-guide/blob/main/image/action.png)

1 Выбрать Settings 
2 Перейти в Runners
3 Выбрать платформу 
4 Перейти на сервер, последовательно внести команды *

__Важно__ *
Необходимо перейти в рабочую директорию, так как именно по этому пути будет находится путь к проекту и директории build.
может потребовать права sudo. 
Для этого не обходимо добавить команду ```RUNNER_ALLOW_RUNASROOT="1"```

Пример
```bash
$ RUNNER_ALLOW_RUNASROOT="1" ./config.sh remove --token ABCDEFG
$ RUNNER_ALLOW_RUNASROOT="1" ./run.sh
```

После можно вернуться в Runners, Status сервер будет иметь состояние Idle
![](https://github.com/ilinaro/Action-guide/blob/main/image/runners.png)





Чтобы не останавливать соединение, перейти в action-runner

```bash
$ sudo ./svc.sh install
$ sudo ./svc.sh start
$ sudo ./svc.sh status
```

![](https://github.com/ilinaro/Action-guide/blob/main/image/svc.png)




## YAML для React приложения
Запуск React App через Action CI/CD не требует установки npm, node. 

```yml
name: React App

on:
  # push - только при отпрвке 
  push:
    branches: [ "main" ]
# jobs зарезервированая команда, указвает на начало работ
jobs:
  # build - можно указать любое название, в данном случае указвает на работу сборки
  build:
    # для соединения с сервером
    runs-on: self-hosted

    # рабочая версия node [16.x, 18.x] или 16
    strategy:
      matrix:
        node-version: [16.x]
    # steps - последовательные действия 
    steps:
    # uses - 3 версия, важно, для входа в систему, позволяет создать доступ к директории с проектом
    - uses: actions/checkout@v3
    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}
        cache: 'npm'
    # npm ci - установка из package-lock.json
    - run: npm i
    - run: npm run build
```

## Запуск React App в Docker
Запуск React App через Docker CI/CD требует установки Docker, также установить make. 

```yml

name: React App in container

on:
  push:
    branches: [ "main" ]

jobs:
  # работа в первом действии build
  build:
    runs-on: self-hosted
    steps:
    - uses: actions/checkout@v3
    - name: Build the Docker image
      run: make build
  # работа start запустит контейнер если build успешен.
  start:
    # needs - создает цепочку зависимостей, при которой будет ожидать, пока не выполнится build. 
    runs-on: self-hosted
    needs: build
    steps:
    - uses: actions/checkout@v3
    - name: Run the Docker container
      run: make run
    - name: Start the Docker container
      run: make start
```

![](https://github.com/ilinaro/Action-guide/blob/main/image/run.png)