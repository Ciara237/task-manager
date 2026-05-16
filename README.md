
# Personal Task Manager

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Features

- Add, edit, and delete tasks
- Filter tasks by All, Pending, or Completed
- Sort tasks by due date or priority
- Task details including category, priority, and due date
- Visual indicators for overdue and high-priority tasks
- Personal profile screen with semester goals

## Tech Stack

- Flutter (Dart)
- Built-in widgets only — no external packages
- State management: StatefulWidget + setState

## Project Structure

```
lib/
├── main.dart
├── models/
│   └── task.dart
├── screens/
│   ├── task_list_screen.dart
│   ├── task_detail_screen.dart
│   └── profile_screen.dart
├── theme/
│   └── app_theme.dart
└── widgets/
    └── task_card.dart
    └── task_editor_sheet.dart
```

## Getting Started

```bash
flutter pub get
flutter run
```

## Author

Ciara Fomunung 
