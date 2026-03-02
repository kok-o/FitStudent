FitStudent Backend

Технологии

- **Java 17**
- **Spring Boot 3.2.5**
- **Spring Data JPA**
- **Spring Security + JWT**
- **PostgreSQL**
- **Lombok**
- **MapStruct**
- **SpringDoc OpenAPI (Swagger)**
- **Maven**

Аутентификация
- Регистрация пользователей
- Авторизация через JWT токены
- Роли: STUDENT, ADMIN

Профиль пользователя
- Личная информация (имя, возраст, пол, рост, вес)
- Цели фитнеса (похудеть, поддерживать, набрать)
- Уровень активности (малоподвижный, умеренный, активный)

Отслеживание активности
- Логирование шагов, калорий, часов сна
- История активности по датам
- Статистика за сегодня

Тренировки
- Тренировки по уровням (BEGINNER, MEDIUM, ADVANCED)
- Отслеживание выполненных тренировок
- Статистика по сожженным калориям

Уведомления
- Системные уведомления
- Мотивационные сообщения
- Отметка о прочтении

API Endpoints

Аутентификация
- `POST /api/auth/register` - Регистрация
- `POST /api/auth/login` - Вход

Профиль
- `GET /api/user/profile` - Получить профиль
- `PUT /api/user/profile` - Обновить профиль

Активность
- `GET /api/activity/logs` - История активности
- `POST /api/activity/log` - Записать активность
- `GET /api/activity/today` - Активность за сегодня

Тренировки
- `GET /api/workouts` - Все тренировки
- `GET /api/workouts/level/{level}` - Тренировки по уровню
- `GET /api/workouts/my-workouts` - Мои тренировки
- `POST /api/workouts/{id}/complete` - Завершить тренировку
- `GET /api/workouts/{id}/completed` - Проверить выполнение

Уведомления
- `GET /api/notifications` - Все уведомления
- `GET /api/notifications/unread` - Непрочитанные
- `GET /api/notifications/unread-count` - Количество непрочитанных
- `PUT /api/notifications/{id}/read` - Отметить как прочитанное

1. Требования
- Java 17+
- Maven 3.6+
- PostgreSQL 12+

2. Настройка базы данных
```sql
CREATE DATABASE fitstudent;
```

3. Настройка переменных окружения
```bash
export JWT_SECRET=your-secret-key-here
```

4. Запуск приложения
```bash
mvn clean install
mvn spring-boot:run
```

5. Swagger UI
После запуска приложения откройте:
http://localhost:8080/swagger-ui.html


Администратор
- Email: admin@fitstudent.com
- Password: admin123

Регистрация
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "student@example.com",
    "password": "password123",
    "name": "John Doe",
    "age": 20,
    "gender": "Male",
    "height": 175.0,
    "weight": 70.0,
    "goal": "MAINTAIN",
    "activityLevel": "MODERATE"
  }'
```

Вход
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "student@example.com",
    "password": "password123"
  }'
```

Docker:
В вашем проекте Docker используется для того, чтобы легко и быстро развернуть всю архитектуру приложения в изолированных контейнерах, не устанавливая вручную кучу зависимостей на свой компьютер.


Запуск docker:
```bash
docker-compose up --build -d
```

Логи всех сервисов:
```bash
docker-compose logs -f
```

Логи только бэкенда:
```bash
docker-compose logs -f backend
```

Остановка docker:
```bash
docker-compose down
```

Перезапуск отдельного сервиса:
```bash
docker-compose up -d --build backend
```

Тесты:
```bash
# Backend tests
mvn test

# Flutter tests
cd frontend_flutter
flutter test
```