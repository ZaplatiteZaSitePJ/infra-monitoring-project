## Безопасная передача файлов

### 1. Генерация SSH-ключей

Создание SSH-ключей:

```bash
ssh-keygen -t ed25519 -C "deployment-key"
```

Создаются два файла:

- `~/.ssh/id_ed25519` - приватный ключ.
- `~/.ssh/id_ed25519.pub` - публичный ключ.

### 2. Копирование публичного ключа на сервер

Установка публичного ключа на удалённый сервер:

```bash
ssh-copy-id username@SERVER_IP
```

Проверка SSH-подключения:

```bash
ssh username@SERVER_IP
```

### 3. Создание архива проекта

Перед отправкой проекта создаётся архив с помощью `tar`:

```bash
tar -czf project.tar.gz \
  --exclude='.git' \
  --exclude='access.log' \
  .
```

### 4. Передача архива через SCP

Копирование архива на сервер:

```bash
scp project.tar.gz username@SERVER_IP:/home/ubuntu/
```

### 5. Развёртывание проекта на сервере

Подключение к серверу:

```bash
ssh username@SERVER_IP
```

Создание рабочей директории:

```bash
mkdir -p ~/monitoring
cd ~/monitoring
```

Распаковка:

```bash
tar -xzf ~/project.tar.gz
```

Запуск:

```bash
docker compose up -d
```

Проверка контейнеров:

```bash
docker compose ps
```

Проверка доступности приложения:

```bash
curl http://localhost:80
```

Ожидаемый ответ:

```text
Monitoring Service Active
```
