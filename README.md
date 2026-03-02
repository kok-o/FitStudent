<<<<<<< HEAD
FitStudent Backend

Технологии
=======
# FitStudent Backend

Полноценный backend для мобильного фитнес-приложения "FitStudent" для студентов колледжа.

## Технологии
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e

- **Java 17**
- **Spring Boot 3.2.5**
- **Spring Data JPA**
- **Spring Security + JWT**
- **PostgreSQL**
- **Lombok**
- **MapStruct**
- **SpringDoc OpenAPI (Swagger)**
- **Maven**

<<<<<<< HEAD
Аутентификация
=======
## Функциональность

### Аутентификация
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
- Регистрация пользователей
- Авторизация через JWT токены
- Роли: STUDENT, ADMIN

<<<<<<< HEAD
Профиль пользователя
=======
### Профиль пользователя
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
- Личная информация (имя, возраст, пол, рост, вес)
- Цели фитнеса (похудеть, поддерживать, набрать)
- Уровень активности (малоподвижный, умеренный, активный)

<<<<<<< HEAD
Отслеживание активности
=======
### Отслеживание активности
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
- Логирование шагов, калорий, часов сна
- История активности по датам
- Статистика за сегодня

<<<<<<< HEAD
Тренировки
=======
### Тренировки
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
- Тренировки по уровням (BEGINNER, MEDIUM, ADVANCED)
- Отслеживание выполненных тренировок
- Статистика по сожженным калориям

<<<<<<< HEAD
Уведомления
=======
### Уведомления
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
- Системные уведомления
- Мотивационные сообщения
- Отметка о прочтении

<<<<<<< HEAD
API Endpoints

Аутентификация
- `POST /api/auth/register` - Регистрация
- `POST /api/auth/login` - Вход

Профиль
- `GET /api/user/profile` - Получить профиль
- `PUT /api/user/profile` - Обновить профиль

Активность
=======
## API Endpoints

### Аутентификация
- `POST /api/auth/register` - Регистрация
- `POST /api/auth/login` - Вход

### Профиль
- `GET /api/user/profile` - Получить профиль
- `PUT /api/user/profile` - Обновить профиль

### Активность
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
- `GET /api/activity/logs` - История активности
- `POST /api/activity/log` - Записать активность
- `GET /api/activity/today` - Активность за сегодня

<<<<<<< HEAD
Тренировки
=======
### Тренировки
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
- `GET /api/workouts` - Все тренировки
- `GET /api/workouts/level/{level}` - Тренировки по уровню
- `GET /api/workouts/my-workouts` - Мои тренировки
- `POST /api/workouts/{id}/complete` - Завершить тренировку
- `GET /api/workouts/{id}/completed` - Проверить выполнение

<<<<<<< HEAD
Уведомления
=======
### Уведомления
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
- `GET /api/notifications` - Все уведомления
- `GET /api/notifications/unread` - Непрочитанные
- `GET /api/notifications/unread-count` - Количество непрочитанных
- `PUT /api/notifications/{id}/read` - Отметить как прочитанное

<<<<<<< HEAD
1. Требования
=======
## Установка и запуск

### 1. Требования
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
- Java 17+
- Maven 3.6+
- PostgreSQL 12+

<<<<<<< HEAD
2. Настройка базы данных
=======
### 2. Настройка базы данных
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
```sql
CREATE DATABASE fitstudent;
```

<<<<<<< HEAD
3. Настройка переменных окружения
=======
### 3. Настройка переменных окружения
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
```bash
export JWT_SECRET=your-secret-key-here
```

<<<<<<< HEAD
4. Запуск приложения
=======
### 4. Запуск приложения
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
```bash
mvn clean install
mvn spring-boot:run
```

<<<<<<< HEAD
5. Swagger UI
После запуска приложения откройте:
http://localhost:8080/swagger-ui.html


Администратор
- Email: admin@fitstudent.com
- Password: admin123

Регистрация
=======
### 5. Swagger UI
После запуска приложения откройте:
http://localhost:8080/swagger-ui.html

### Администратор
- **Email:** admin@fitstudent.com
- **Password:** admin123

### Тренировки
- **Morning Stretch** (BEGINNER) - 15 мин, 50 калорий
- **Cardio Blast** (MEDIUM) - 30 мин, 200 калорий  
- **HIIT Challenge** (ADVANCED) - 45 мин, 400 калорий

## Структура проекта

```
src/main/java/com/cursorai/fitnessapp/
├── FitnessAppApplication.java
├── controller/          # REST контроллеры
├── service/            # Бизнес-логика
├── repository/         # JPA репозитории
├── model/              # Сущности базы данных
├── dto/                # Data Transfer Objects
├── mapper/             # MapStruct мапперы
├── config/             # Конфигурация
├── security/           # JWT и Security
└── exception/          # Обработка ошибок
```

## Примеры запросов

### Регистрация
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
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

<<<<<<< HEAD
Вход
=======
### Вход
>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "student@example.com",
    "password": "password123"
  }'
```

<<<<<<< HEAD
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
=======


>>>>>>> f37639c6a57385e5540cedd429fb442423c5077e
