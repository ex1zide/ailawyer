class AppConstants {
  // API
  static const String baseUrl = 'https://api.legalhelp.kz/v1';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String languageKey = 'app_language';
  static const String onboardingKey = 'onboarding_complete';
  static const String themeKey = 'theme_mode';

  // App Info
  static const String appName = 'LegalHelp KZ';
  static const String appVersion = '1.0.0';

  // Languages
  static const String langRussian = 'ru';
  static const String langKazakh = 'kk';

  // Cities
  static const List<String> kazakhstanCities = [
    'Алматы',
    'Астана',
    'Шымкент',
    'Актобе',
    'Қарағанды',
    'Тараз',
    'Павлодар',
    'Өскемен',
    'Семей',
    'Атырау',
    'Ақтау',
    'Қызылорда',
    'Орал',
    'Петропавл',
    'Темиртау',
    'Қостанай',
    'Экібастұз',
  ];

  // Categories
  static const List<String> legalCategories = [
    'ДТП',
    'Трудовое',
    'Семейное',
    'Недвижимость',
    'Бизнес',
    'Документы',
    'Уголовное',
    'Налоговое',
  ];

  // Emergency Numbers
  static const String policeNumber = '102';
  static const String ambulanceNumber = '103';
  static const String emergencyNumber = '112';
  static const String fireDeptNumber = '101';

  // Subscription Plans
  static const String freePlan = 'free';
  static const String proPlan = 'pro';

  // Quick Chat Replies (Russian)
  static const List<String> quickReplies = [
    'Какие у меня права?',
    'Как подать на развод?',
    'Что делать после ДТП?',
    'Как составить договор?',
    'Трудовые споры',
  ];

  // Interests list
  static const List<String> interestsList = [
    'ДТП',
    'Семейное право',
    'Трудовые споры',
    'Недвижимость',
    'Бизнес',
    'Уголовное',
    'Налоговое',
    'Наследство',
    'Административное',
  ];
}
