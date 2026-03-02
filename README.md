# LegalHelp KZ 🇰🇿⚖️

> AI-powered Legal Assistant for Kazakhstan — Flutter Mobile Application

## Overview

LegalHelp KZ is a premium Flutter mobile application providing AI-powered legal assistance for citizens of Kazakhstan. The app features a stunning dark theme with gold accents and offers comprehensive legal services.

---

## ✨ Features

| Feature | Description |
|---|---|
| 🤖 **AI Chat** | Real-time legal Q&A based on Kazakhstan law |
| 👨‍⚖️ **Lawyer Marketplace** | Find & book verified lawyers nearby |
| 📄 **Document Scanner** | OCR-powered document scanning |
| 📅 **Booking System** | Multi-step consultation booking flow |
| 🔔 **Notifications** | Smart push notifications |
| 📰 **Legal News** | Latest Kazakhstan legal updates |
| 🆘 **Emergency Contacts** | Quick access to legal & emergency numbers |
| 💎 **Subscription Plans** | Free, Pro, and Business tiers |

---

## 🖥️ Screens (30 total)

### Auth Flow (5 screens)
- `SplashScreen` → Animated logo
- `OnboardingScreen` → 3-step welcome screens
- `PhoneAuthScreen` → +7 KZ phone input
- `SMSVerificationScreen` → 6-digit OTP
- `ProfileSetupScreen` → Name & avatar setup

### Main (5 screens)
- `HomeDashboardScreen` → Dashboard with categories & quick actions
- `SearchScreen` → Filter search with trending topics
- `AIChatScreen` → Full AI chat with message bubbles
- `NotificationsScreen` → Swipe-to-dismiss notifications
- `ProfileScreen` → User stats and menu

### Lawyers (3 screens)
- `LawyerMarketplaceScreen` → Filtered list with sort
- `LawyerProfileScreen` → Full profile with reviews
- `SavedLawyersScreen` → Bookmarked lawyers

### Bookings (4 screens)
- `BookingFlowScreen` → Date picker + type selector + confirm
- `MyBookingsScreen` → Upcoming/past tabs
- `PaymentScreen` → Payment method selection
- `PaymentSuccessScreen` → Animated success

### Documents (2 screens)
- `DocumentScannerScreen` → Camera + OCR scanner
- `DocumentLibraryScreen` → Grid filtered library

### News & Emergency (3 screens)
- `LegalNewsScreen` → Category-filtered news
- `EmergencyContactsScreen` → Tap-to-call emergency numbers
- `HelpSupportScreen` → FAQ accordion + support options

### Profile & Settings (4 screens)
- `UserProfileScreen` → Edit name & avatar
- `SettingsScreen` → Notifications, language, biometric
- `SubscriptionPlansScreen` → Monthly/yearly billing toggle
- `PaymentMethodsScreen` → Add/remove payment methods

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| **Flutter 3.x** | Cross-platform mobile framework |
| **Riverpod 2.x** | State management |
| **GoRouter** | Declarative navigation |
| **Dio** | HTTP client |
| **Hive / SharedPreferences** | Local storage |
| **google_mlkit_text_recognition** | OCR for documents |

---

## 🎨 Design System

```
Background:   #0A0A0A (Deep Black)
Surface:      #1F1F1F (Dark Gray)
Accent:       #D4AF37 (Gold)
Text:         #FFFFFF / #9CA3AF / #6B7280
Success:      #22C55E
Error:        #EF4444
```

Font: **Inter** (Regular, Medium, SemiBold, Bold)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio / Xcode

### Setup

```bash
# 1. Clone the repo
git clone <repo-url>
cd legalhelp_kz

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

> 💡 **Typography**: the app uses `google_fonts` for the premium **Inter** font. No manual font download is required.
> 📱 **Design**: The app is optimized for **mobile dimensions** (centrered 450px layout on Web/Desktop).

> 💡 **Demo Login**: Enter any phone number → use OTP code **123456**

---

## 📁 Project Structure

```
lib/
├── app.dart                    # Root MaterialApp.router
├── main.dart                   # Entry point
├── config/
│   ├── constants.dart          # App constants
│   ├── routes.dart             # GoRouter (30 routes)
│   └── theme.dart              # AppColors + AppTheme
├── core/
│   ├── models/models.dart      # All data models
│   └── utils/mock_data.dart    # Mock data
├── features/
│   ├── auth/screens/           # Splash, Onboarding, Auth
│   ├── chat/screens/           # AI Chat
│   ├── home/screens/           # Home, Search, Notifications
│   ├── lawyers/screens/        # Marketplace, Profile, Saved
│   ├── bookings/screens/       # Booking, Payment
│   ├── documents/screens/      # Scanner, Library
│   ├── news/screens/           # News, Emergency, Help
│   └── profile/screens/        # Profile, Settings, Plans
├── providers/providers.dart    # Riverpod state providers
└── widgets/common/             # Shared UI components
```

---

## 📞 API Integration

Base URL: `https://api.legalhelp.kz/v1`

Currently using **mock data** for all features. Replace `MockData` with real API calls via the `Dio` client when backend is ready.

---

*Built with ❤️ for Kazakhstan*
