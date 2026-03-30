import 'package:flutter/material.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/config/theme.dart';

class MockData {
  // ─── User ────────────────────────────────────────────────────────────
  static const User currentUser = User(
    id: 'user_001',
    phone: '+7 777 123 4567',
    firstName: 'Айгерим',
    lastName: 'Сейткали',
    city: 'Алматы',
    language: 'ru',
    interests: ['ДТП', 'Семейное право', 'Недвижимость'],
    plan: SubscriptionPlan.free,
    questionsAsked: 12,
    documentsScanned: 5,
    lawyersContacted: 3,
  );

  // ─── Categories ──────────────────────────────────────────────────────
  static const List<Category> categories = [
    Category(
      id: 'dtp',
      name: 'ДТП',
      icon: '🚗',
      color: Color(0xFFEF4444),
    ),
    Category(
      id: 'labor',
      name: 'Трудовое',
      icon: '💼',
      color: Color(0xFF3B82F6),
    ),
    Category(
      id: 'family',
      name: 'Семейное',
      icon: '❤️',
      color: Color(0xFFEC4899),
    ),
    Category(
      id: 'realestate',
      name: 'Недвижимость',
      icon: '🏠',
      color: Color(0xFF22C55E),
    ),
    Category(
      id: 'business',
      name: 'Бизнес',
      icon: '🏢',
      color: Color(0xFFF59E0B),
    ),
    Category(
      id: 'documents',
      name: 'Документы',
      icon: '📄',
      color: Color(0xFF8B5CF6),
    ),
  ];

  // ─── Lawyers ─────────────────────────────────────────────────────────
  static final List<Lawyer> lawyers = [
    const Lawyer(
      id: 'l001',
      name: 'Ерлан Касымов',
      rating: 4.9,
      reviewCount: 127,
      specialization: 'Специалист по ДТП и страхованию',
      categories: ['ДТП'],
      distance: 1.2,
      price: 15000,
      isVerified: true,
      isOnline: true,
      about: 'Опытный юрист с 10-летним стажем в области дорожно-транспортных происшествий. Помог более 500 клиентам получить компенсацию.',
      experience: 10,
      casesWon: 340,
    ),
    const Lawyer(
      id: 'l002',
      name: 'Мадина Әбенова',
      rating: 4.8,
      reviewCount: 89,
      specialization: 'Семейный и гражданский юрист',
      categories: ['Семейное'],
      distance: 2.5,
      price: 12000,
      isVerified: true,
      isOnline: false,
      about: 'Специализируюсь на семейных делах: развод, раздел имущества, алименты, усыновление.',
      experience: 8,
      casesWon: 210,
    ),
    const Lawyer(
      id: 'l003',
      name: 'Темirлан Нұрманов',
      rating: 4.7,
      reviewCount: 64,
      specialization: 'Трудовые споры и увольнения',
      categories: ['Трудовое'],
      distance: 3.8,
      price: 10000,
      isVerified: true,
      isOnline: true,
      about: 'Помогаю работникам защитить свои права. Специализируюсь на незаконных увольнениях и трудовых договорах.',
      experience: 6,
      casesWon: 175,
    ),
    const Lawyer(
      id: 'l004',
      name: 'Гульнара Сейіткали',
      rating: 4.6,
      reviewCount: 45,
      specialization: 'Недвижимость и жилищные споры',
      categories: ['Недвижимость'],
      distance: 0.8,
      price: 18000,
      isVerified: false,
      isOnline: true,
      about: 'Сделки с недвижимостью, споры с застройщиками, ипотечные вопросы.',
      experience: 12,
      casesWon: 290,
    ),
    const Lawyer(
      id: 'l005',
      name: 'Асхат Дюсенов',
      rating: 4.5,
      reviewCount: 33,
      specialization: 'Бизнес и корпоративное право',
      categories: ['Бизнес'],
      distance: 5.1,
      price: 25000,
      isVerified: true,
      isOnline: false,
      about: 'Регистрация бизнеса, договоры, налоговые споры, защита бизнеса.',
      experience: 15,
      casesWon: 420,
    ),
    const Lawyer(
      id: 'l006',
      name: 'Жанар Бекова',
      rating: 4.9,
      reviewCount: 98,
      specialization: 'Уголовные дела и защита',
      categories: ['Уголовное'],
      distance: 2.2,
      price: 30000,
      isVerified: true,
      isOnline: true,
      about: 'Защита по уголовным делам, апелляции, работа со следствием.',
      experience: 14,
      casesWon: 380,
    ),
  ];

  // ─── Chat Messages ───────────────────────────────────────────────────
  static List<ChatMessage> initialMessages = [
    ChatMessage(
      id: 'msg_001',
      text: 'Здравствуйте! Я ваш AI-юрист. Я могу помочь с вопросами по законодательству Казахстана. Задайте ваш вопрос.',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatMessage(
      id: 'msg_002',
      text: 'Что делать если работодатель задерживает зарплату?',
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
    ChatMessage(
      id: 'msg_003',
      text: 'Согласно Трудовому кодексу РК (ст. 113), работодатель обязан выплачивать заработную плату не реже одного раза в месяц.\n\n**Ваши действия:**\n1. Письменно уведомите работодателя о задержке\n2. Обратитесь в Трудовую инспекцию (ГТИ)\n3. Подайте жалобу в прокуратуру\n4. Обратитесь в суд\n\nЗа задержку зарплаты работодатель несёт административную (ст. 87 КоАП) и уголовную (ст. 152 УК РК) ответственность.',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      sources: ['Трудовой кодекс РК, ст. 113', 'КоАП РК, ст. 87'],
    ),
  ];

  // ─── Notifications ───────────────────────────────────────────────────
  static List<AppNotification> notifications = [
    AppNotification(
      id: 'n001',
      title: 'Консультация подтверждена',
      body: 'Ерлан Касымов подтвердил встречу на 15 марта в 14:00',
      type: NotificationType.booking,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    AppNotification(
      id: 'n002',
      title: 'Новый закон о труде',
      body: 'В Казахстане изменились правила расчёта больничного листа',
      type: NotificationType.system,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    AppNotification(
      id: 'n003',
      title: 'Ответ от AI-юриста',
      body: 'Ваш вопрос о разводе получил подробный ответ',
      type: NotificationType.chat,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    AppNotification(
      id: 'n004',
      title: 'Специальное предложение',
      body: 'Первый месяц Pro-подписки — 50% скидка! Успейте до 31 марта',
      type: NotificationType.promo,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    AppNotification(
      id: 'n005',
      title: 'Документ отсканирован',
      body: 'Договор аренды успешно распознан и сохранён в библиотеке',
      type: NotificationType.system,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  // ─── Bookings ────────────────────────────────────────────────────────
  static List<Booking> bookings = [
    Booking(
      id: 'b001',
      lawyer: lawyers[0],
      dateTime: DateTime.now().add(const Duration(days: 3, hours: 2)),
      type: ConsultationType.online,
      status: BookingStatus.upcoming,
      price: 15000,
    ),
    Booking(
      id: 'b002',
      lawyer: lawyers[1],
      dateTime: DateTime.now().subtract(const Duration(days: 7)),
      type: ConsultationType.phone,
      status: BookingStatus.completed,
      price: 12000,
    ),
    Booking(
      id: 'b003',
      lawyer: lawyers[2],
      dateTime: DateTime.now().subtract(const Duration(days: 14)),
      type: ConsultationType.inPerson,
      status: BookingStatus.cancelled,
      price: 10000,
    ),
  ];

  // ─── Documents ───────────────────────────────────────────────────────
  static List<Document> documents = [
    Document(
      id: 'd001',
      name: 'Договор аренды квартиры',
      type: 'Contracts',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      extractedText: 'Договор аренды жилого помещения...',
      size: 245760,
    ),
    Document(
      id: 'd002',
      name: 'Решение суда №145',
      type: 'Court',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      size: 512000,
    ),
    Document(
      id: 'd003',
      name: 'Трудовой договор',
      type: 'Contracts',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      size: 189440,
    ),
    Document(
      id: 'd004',
      name: 'Паспорт (скан)',
      type: 'Personal',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      size: 1048576,
    ),
  ];

  // ─── News ────────────────────────────────────────────────────────────
  static List<LegalNews> news = [
    LegalNews(
      id: 'news001',
      title: 'В Казахстане изменили порядок регистрации ИП',
      summary: 'С 1 марта 2026 года упрощена процедура регистрации индивидуальных предпринимателей. Теперь можно зарегистрироваться через eGov за 30 минут.',
      category: 'Бизнес',
      publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
      source: 'Zakon.kz',
      url: 'https://www.zakon.kz/5423123-v-rk-upostili-registraci-ip.html',
    ),
    LegalNews(
      id: 'news002',
      title: 'Новые штрафы за нарушение ПДД',
      summary: 'Мажилис принял поправки в КоАП, увеличивающие штрафы за превышение скорости в 2 раза с апреля 2026 года.',
      category: 'ДТП',
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      source: 'Tengrinews',
      url: 'https://tengrinews.kz/kazakhstan_news/novyie-shtrafyi-za-narushenie-pdd-491234/',
    ),
    LegalNews(
      id: 'news003',
      title: 'Изменения в Трудовом кодексе: больничные листы',
      summary: 'С апреля 2026 года работники смогут оформлять электронные больничные листы без посещения врача при лёгких заболеваниях.',
      category: 'Трудовое',
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      source: 'Kapital.kz',
      url: 'https://kapital.kz/economic/123456/izmeneniya-v-tk-rk-bol-nichnyye.html',
    ),
    LegalNews(
      id: 'news004',
      title: 'Верховный суд разъяснил порядок раздела имущества',
      summary: 'Пленум Верховного суда РК выпустил разъяснения по сложным вопросам раздела совместно нажитого имущества при разводе.',
      category: 'Семейное',
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
      source: 'Zakon.kz',
      url: 'https://www.zakon.kz/5423456-verhovnyy-sud-rk.html',
    ),
    LegalNews(
      id: 'news005',
      title: 'Изменения в жилищном законодательстве 2026',
      summary: 'Новый закон обязывает застройщиков страховать ответственность перед дольщиками. Принят в первом чтении.',
      category: 'Недвижимость',
      publishedAt: DateTime.now().subtract(const Duration(days: 4)),
      source: 'Forbes Kazakhstan',
      url: 'https://forbes.kz/process/property/novyiy_zakon_o_dolevom_stroitelstve/',
    ),
  ];

  // ─── Emergency Contacts ──────────────────────────────────────────────
  static const List<EmergencyContact> emergencyContacts = [
    EmergencyContact(
      id: 'e001',
      name: 'Полиция',
      phone: '102',
      description: 'Правоохранительные органы',
      isAvailable24h: true,
      icon: '🚔',
    ),
    EmergencyContact(
      id: 'e002',
      name: 'Скорая помощь',
      phone: '103',
      description: 'Медицинская помощь',
      isAvailable24h: true,
      icon: '🚑',
    ),
    EmergencyContact(
      id: 'e003',
      name: 'Единая служба спасения',
      phone: '112',
      description: 'Пожар, ЧС, авария',
      isAvailable24h: true,
      icon: '🆘',
    ),
    EmergencyContact(
      id: 'e004',
      name: 'Пожарная служба',
      phone: '101',
      description: 'Пожаротушение и спасение',
      isAvailable24h: true,
      icon: '🚒',
    ),
    EmergencyContact(
      id: 'e005',
      name: 'Бесплатная юридическая помощь',
      phone: '1414',
      description: 'Государственная юрпомощь',
      isAvailable24h: false,
      icon: '⚖️',
    ),
    EmergencyContact(
      id: 'e006',
      name: 'Антикоррупционная служба',
      phone: '1424',
      description: 'Коррупционные правонарушения',
      isAvailable24h: true,
      icon: '🏛️',
    ),
  ];

  // ─── Reviews ─────────────────────────────────────────────────────────
  static List<Review> getReviewsForLawyer(String lawyerId) {
    return [
      Review(
        id: 'r001',
        authorName: 'Нұрлан К.',
        rating: 5.0,
        comment: 'Отличный специалист! Помог выиграть дело о ДТП. Очень профессиональный и отзывчивый.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Review(
        id: 'r002',
        authorName: 'Айжан М.',
        rating: 5.0,
        comment: 'Быстро и грамотно разобрался с моим вопросом. Рекомендую!',
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      Review(
        id: 'r003',
        authorName: 'Серик Б.',
        rating: 4.0,
        comment: 'Хороший юрист, объяснил все доступно. Немного долго отвечал, но результат хороший.',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
    ];
  }

  // ─── Recent Questions ────────────────────────────────────────────────
  static const List<Map<String, String>> recentQuestions = [
    {
      'question': 'Как получить выходное пособие при увольнении?',
      'time': '2 часа назад',
      'category': 'Трудовое',
    },
    {
      'question': 'Каковы права при ДТП не по моей вине?',
      'time': 'Вчера',
      'category': 'ДТП',
    },
    {
      'question': 'Как оспорить завещание?',
      'time': '3 дня назад',
      'category': 'Семейное',
    },
  ];

  // ─── Payment Methods ─────────────────────────────────────────────────
  static const List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      id: 'pm001',
      name: 'Kaspi Gold',
      maskedNumber: '**** 4567',
      type: 'kaspi',
      isDefault: true,
    ),
    PaymentMethod(
      id: 'pm002',
      name: 'Halyk Bank',
      maskedNumber: '**** 8901',
      type: 'halyk',
    ),
    PaymentMethod(
      id: 'pm003',
      name: 'Visa Card',
      maskedNumber: '**** 2345',
      type: 'card',
    ),
  ];

  // ─── Saved Lawyers ───────────────────────────────────────────────────
  static List<Lawyer> get savedLawyers => [lawyers[0], lawyers[2], lawyers[5]];
}

