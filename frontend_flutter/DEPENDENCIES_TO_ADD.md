# Зависимости для добавления в pubspec.yaml

Добавьте следующие зависимости в файл `pubspec.yaml`:

```yaml
dependencies:
  # Existing dependencies...
  
  # UI/UX Enhancements
  google_fonts: ^6.1.0
  shimmer: ^3.0.0
  timeago: ^3.6.0
  shared_preferences: ^2.2.2
  
  # Already included (verify versions)
  flutter_riverpod: ^2.4.9
  go_router: ^13.0.0
```

## Команды для установки:

```bash
cd frontend_flutter
flutter pub add google_fonts
flutter pub add shimmer
flutter pub add timeago
flutter pub add shared_preferences
flutter pub get
```

## Примечание:
- `google_fonts` - для использования шрифта Inter
- `shimmer` - для эффектов загрузки
- `timeago` - для отображения относительного времени
- `shared_preferences` - для сохранения настроек темы
