# 🏨 MyTravaly Task

A Flutter-based hotel search and booking prototype application built with clean architecture, BLoC state management, and repository pattern.

---

## 🚀 Getting Started

This project serves as a foundation for building scalable and maintainable Flutter apps. It integrates API services, authentication, and modular presentation layers.

---

## 🧩 Tech Stack

- **Framework:** Flutter `3.35.2`
- **Language:** Dart `>=3.0.0`
- **State Management:** [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Responsive UI:** `flutter_screenutil`
- **Logging:** Custom `logger`

---

## ⚙️ Environment Setup

### 1️⃣ Install Flutter
Ensure Flutter `3.35.2` is installed or You can use fvm as well.
You can check your Flutter version with:

```bash
flutter --version
dart pub global activate fvm
fvm install 3.35.2
fvm use
```

### 2️⃣ Project Configuration
Create a `.env` file in the root directory with the following environment variables:

```bash
# .env
BASE_URL=https://your-api-base-url.com
```

## ⚙️ Environment Setup

### Install Dependencies
```bash
flutter pub get

#if using fvm
fvm flutter pub get

```
