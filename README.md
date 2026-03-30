# LegalHelp KZ 🇰🇿⚖️

> AI-powered Legal Assistant for Kazakhstan — Flutter Mobile Application

## Overview

LegalHelp KZ is a premium Flutter mobile application providing AI-powered legal assistance for citizens of Kazakhstan. The app features a stunning dark theme with gold accents and offers comprehensive legal services.

---

## ✨ Features

| Feature | Description |
|---|---|
| 🤖 **AI Chat** | Real-time legal Q&A based on Kazakhstan law (Gemini AI) |
| 👨‍⚖️ **Lawyer Marketplace** | Find & book verified lawyers nearby |
| 📄 **Document Scanner** | OCR-powered document scanning |
| 📅 **Booking System** | Multi-step consultation booking flow |
| 🔔 **Notifications** | Smart push notifications |
| 📰 **Legal News** | Latest Kazakhstan legal updates (RSS) |
| 🆘 **Emergency Contacts** | Quick access to legal & emergency numbers |
| 💎 **Subscription Plans** | Free, Pro, and Business tiers |
| 🌐 **Bilingual** | Русский / Қазақша |
| 📡 **Offline Mode** | Firestore cache (50MB) for offline access |

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| **Flutter 3.x** | Cross-platform mobile framework |
| **Firebase** | Auth, Firestore, Storage |
| **Riverpod 2.x** | State management |
| **GoRouter** | Declarative navigation with Auth Guard |
| **Gemini AI** | AI-powered legal consultations |
| **Dio** | HTTP client |
| **SharedPreferences** | Local storage |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+
- Firebase project configured

### Setup

```bash
# 1. Clone the repo
git clone https://github.com/ex1zide/ailawyer.git
cd ailawyer

# 2. Install dependencies
flutter pub get

# 3. Run on Chrome
flutter run -d chrome
```

> 💡 **Demo Login**: Enter any phone number → use OTP code **123456** (debug mode only)

---

## 📱 Запуск на телефоне

### iPhone (через Wi-Fi)

Без Mac можно запустить веб-версию прямо на iPhone:

```bash
# 1. Запусти веб-сервер на всех интерфейсах
flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0

# 2. Узнай IP компьютера
ipconfig    # Windows
ifconfig    # macOS/Linux
```

3. Убедись что iPhone и компьютер в **одной Wi-Fi сети**
4. Открой на iPhone в Safari:
```
http://<IP-компьютера>:8080
```

5. *(Опционально)* Добавь на домашний экран:
   - Нажми кнопку **«Поделиться»** → **«На экран "Домой"»**

> ⚠️ **Если не грузит**: откройте порт в фаерволе:
> ```bash
> netsh advfirewall firewall add rule name="Flutter Web" dir=in action=allow protocol=TCP localport=8080
> ```

### Android (USB)

```bash
# 1. Включи USB-отладку на телефоне
#    Настройки → О телефоне → 7x нажми "Номер сборки"
#    Настройки → Для разработчиков → USB-отладка → ВКЛ

# 2. Подключи USB и запусти
flutter run

# Или собери APK
flutter build apk --release
# APK: build/app/outputs/flutter-apk/app-release.apk
```

### iOS (нужен Mac)

```bash
flutter build ios --release
# Затем через Xcode → устройство или TestFlight
```

---

## 📁 Project Structure

```
lib/
├── app.dart                    # Root MaterialApp.router
├── main.dart                   # Entry point + Firebase init
├── config/
│   ├── constants.dart          # App constants
│   ├── routes.dart             # GoRouter (30 routes + Auth Guard)
│   └── theme.dart              # AppColors + AppTheme
├── core/
│   ├── api/api_client.dart     # Dio HTTP client
│   ├── auth/auth_service.dart  # Firebase Auth
│   ├── models/models.dart      # All data models
│   ├── services/               # 8 backend services
│   │   ├── booking_service.dart
│   │   ├── chat_service.dart
│   │   ├── document_service.dart
│   │   ├── firestore_service.dart
│   │   ├── lawyer_service.dart
│   │   ├── news_service.dart
│   │   ├── openai_service.dart
│   │   ├── storage_service.dart
│   │   └── user_service.dart
│   └── utils/
│       ├── list_extensions.dart
│       ├── mock_data.dart
│       ├── translations.dart   # RU/KZ translations
│       └── firestore_seeder.dart
├── features/
│   ├── auth/                   # Splash, Onboarding, Login, Register
│   ├── chat/                   # AI Chat + Repository
│   ├── home/                   # Dashboard, Search, Notifications
│   ├── lawyers/                # Marketplace, Profile, Saved
│   ├── bookings/               # Booking, Payment
│   ├── documents/              # Scanner, Library
│   ├── news/                   # News, Emergency, Help
│   └── profile/                # Profile, Settings, Plans
├── providers/providers.dart    # Riverpod providers + state
└── widgets/common/
    ├── widgets.dart            # GoldButton, AppBar, etc.
    ├── shimmer_loading.dart    # Skeleton loading animations
    ├── error_widget.dart       # Error + Offline widgets
    └── main_shell.dart         # Bottom navigation shell
```

---

## 🔒 Security

- OTP bypass (`123456`) works only in **debug mode** (`kDebugMode`)
- API keys injected via `--dart-define` (not hardcoded)
- Auth Guard prevents unauthenticated access to protected routes
- Firestore security rules enforce user-level data access

---

## 🎨 Design System

```
Background:   #000000 (Deep Black)
Surface:      #0A0A0F (Dark)
Accent:       #FFFFFF / #3B82F6 (White + Blue)
Text:         #FFFFFF / #9CA3AF / #6B7280
Success:      #22C55E
Error:        #EF4444
```

Font: **Inter** via `google_fonts`

---

*Built with ❤️ for Kazakhstan*
