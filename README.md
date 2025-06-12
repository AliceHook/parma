# API для обработки Zoom-записей

Приложение предоставляет два эндпоинта для запуска n8n workflow и получения результатов его выполнения.

## Эндпоинты

### POST `/api/v1/process_zoom_recording`
Запускает обработку Zoom‑записи.

**Тело запроса**
```json
{
  "zoom_url": "https://zoom.us/rec/example"
}
```

**Успешный ответ** `200`
```json
{ "status": "accepted" }
```

### POST `/api/v1/n8n_callback`
Принимает результат работы workflow.

**Формат запроса**
```json
{
  "summary": "Краткое описание встречи...",
  "bant": {
    "budget": "Бюджет",
    "authority": "Ответственный",
    "need": "Потребность",
    "timing": "Сроки"
  },
  "transcript": "Полный текст транскрипта..."
}
```

Ответ всегда `200`.

## Примеры использования

```bash
# Запуск обработки
curl -X POST http://localhost:3000/api/v1/process_zoom_recording \
  -H 'Content-Type: application/json' \
  -d '{"zoom_url":"https://zoom.us/rec/example"}'
```

## Переменные окружения

- `N8N_WEBHOOK_URL` – адрес вебхука n8n, на который будет отправлен `zoom_url`.

## Логирование

Все входящие и исходящие запросы пишутся в стандартный `log/development.log` (или соответствующий лог среды). Для просмотра логов используйте:

```bash
tail -f log/development.log
```

## Развертывание и тестирование

1. Установите зависимости: `bundle install`.
2. Запустите сервер: `bin/rails server`.
3. Запустите тесты: `bundle exec rails test`.
