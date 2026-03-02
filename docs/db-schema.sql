-- Draft SQL schema for MVP

-- Users
CREATE TABLE IF NOT EXISTS users (
  id BIGSERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  name VARCHAR(255),
  age INT,
  gender VARCHAR(20),
  height DOUBLE PRECISION,
  weight DOUBLE PRECISION,
  goal VARCHAR(20), -- LOSE, MAINTAIN, GAIN
  activity_level VARCHAR(20), -- SEDENTARY, MODERATE, ACTIVE
  role VARCHAR(20) NOT NULL DEFAULT 'STUDENT',
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Preferences
CREATE TABLE IF NOT EXISTS user_preferences (
  user_id BIGINT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  preferred_training_types TEXT, -- JSON array of strings
  preferred_time_of_day VARCHAR(20),
  equipment TEXT -- JSON array of strings
);

-- Activity points (steps, calories, sleep minutes)
CREATE TABLE IF NOT EXISTS activity_points (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type VARCHAR(20) NOT NULL, -- steps|calories|sleep
  timestamp TIMESTAMP NOT NULL,
  value DOUBLE PRECISION NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_activity_points_user_time ON activity_points(user_id, timestamp);
CREATE INDEX IF NOT EXISTS idx_activity_points_type ON activity_points(type);

-- Water
CREATE TABLE IF NOT EXISTS water_entries (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  timestamp TIMESTAMP NOT NULL,
  ml INT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_water_user_time ON water_entries(user_id, timestamp);

-- Nutrition
CREATE TABLE IF NOT EXISTS nutrition_entries (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  timestamp TIMESTAMP NOT NULL,
  food TEXT NOT NULL,
  calories INT,
  protein_g DOUBLE PRECISION,
  fat_g DOUBLE PRECISION,
  carbs_g DOUBLE PRECISION
);
CREATE INDEX IF NOT EXISTS idx_nutrition_user_time ON nutrition_entries(user_id, timestamp);

-- Workouts catalog
CREATE TABLE IF NOT EXISTS workouts (
  id BIGSERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  type VARCHAR(20) NOT NULL, -- cardio|strength|yoga|stretch
  level VARCHAR(20) NOT NULL, -- BEGINNER|MEDIUM|ADVANCED
  expected_duration_min INT,
  expected_calories INT,
  media_urls TEXT -- JSON array
);

-- User workout history
CREATE TABLE IF NOT EXISTS user_workouts (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  workout_id BIGINT NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
  completed_at TIMESTAMP NOT NULL DEFAULT NOW(),
  actual_duration INT,
  actual_calories INT
);
CREATE INDEX IF NOT EXISTS idx_user_workouts_user_time ON user_workouts(user_id, completed_at);

-- Workout plans (simple)
CREATE TABLE IF NOT EXISTS workout_plans (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  description TEXT
);

-- Plan days mapping
CREATE TABLE IF NOT EXISTS workout_plan_days (
  id BIGSERIAL PRIMARY KEY,
  plan_id BIGINT NOT NULL REFERENCES workout_plans(id) ON DELETE CASCADE,
  day_of_week INT NOT NULL CHECK (day_of_week BETWEEN 1 AND 7),
  workout_id BIGINT NOT NULL REFERENCES workouts(id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS idx_plan_days_plan_day ON workout_plan_days(plan_id, day_of_week);

-- Notifications
CREATE TABLE IF NOT EXISTS notifications (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  body TEXT,
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_notifications_user_time ON notifications(user_id, created_at);

-- Notification settings
CREATE TABLE IF NOT EXISTS notification_settings (
  user_id BIGINT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  workout_reminders BOOLEAN DEFAULT TRUE,
  water_reminders BOOLEAN DEFAULT TRUE,
  daily_goal_reminders BOOLEAN DEFAULT TRUE,
  quiet_hours_start VARCHAR(10),
  quiet_hours_end VARCHAR(10)
);
