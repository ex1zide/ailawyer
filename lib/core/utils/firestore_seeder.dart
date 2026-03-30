import 'package:cloud_firestore/cloud_firestore.dart';

/// Seeds the Firestore database with initial data for testing and demo.
/// Run once from the app (e.g., from admin screen or debug menu).
class FirestoreSeeder {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Seeds all data collections.
  Future<void> seedAll() async {
    await seedLawyers();
  }

  /// Populates the `lawyers` collection with realistic Kazakhstan lawyers.
  Future<void> seedLawyers() async {
    final lawyers = _kazakhstanLawyers();

    // Fetch all existing lawyer IDs in one query
    final existingDocs = await _db.collection('lawyers').get();
    final existingIds = existingDocs.docs.map((d) => d.id).toSet();

    final batch = _db.batch();
    bool hasNewData = false;
    for (final lawyer in lawyers) {
      final id = lawyer['id'] as String;
      if (!existingIds.contains(id)) {
        batch.set(_db.collection('lawyers').doc(id), lawyer);
        hasNewData = true;
      }
    }
    if (hasNewData) await batch.commit();
  }

  List<Map<String, dynamic>> _kazakhstanLawyers() {
    return [
      {
        'id': 'lawyer_001',
        'name': 'Алмас Бейсенов',
        'photo_url': null,
        'specialization': 'Трудовое право',
        'categories': ['Трудовое право', 'Корпоративное право'],
        'rating': 4.9,
        'review_count': 124,
        'price': 8000,
        'city': 'Алматы',
        'distance': 1.2,
        'is_verified': true,
        'is_online': true,
        'isActive': true,
        'experience': 12,
        'cases_won': 98,
        'about':
            'Специализируюсь на трудовых спорах и корпоративном праве. Более 12 лет успешной практики в Казахстане. Помог более 500 клиентам восстановить свои права.',
      },
      {
        'id': 'lawyer_002',
        'name': 'Айгерим Сейткали',
        'photo_url': null,
        'specialization': 'Семейное право',
        'categories': ['Семейное право', 'Жилищное право'],
        'rating': 4.8,
        'review_count': 97,
        'price': 7000,
        'city': 'Алматы',
        'distance': 2.5,
        'is_verified': true,
        'is_online': false,
        'isActive': true,
        'experience': 9,
        'cases_won': 83,
        'about':
            'Эксперт по семейным спорам: развод, алименты, раздел имущества. Защищаю интересы детей и родителей. Более 300 выигранных дел.',
      },
      {
        'id': 'lawyer_003',
        'name': 'Руслан Дюсенов',
        'photo_url': null,
        'specialization': 'Уголовное право',
        'categories': ['Уголовное право', 'Административное право'],
        'rating': 4.7,
        'review_count': 156,
        'price': 12000,
        'city': 'Астана',
        'distance': 0.8,
        'is_verified': true,
        'is_online': true,
        'isActive': true,
        'experience': 15,
        'cases_won': 142,
        'about':
            'Адвокат с 15-летним стажем. Специализируюсь на защите по уголовным делам. Бывший прокурор, отлично знаю внутреннюю систему. Работаю во всех регионах РК.',
      },
      {
        'id': 'lawyer_004',
        'name': 'Дина Ахметова',
        'photo_url': null,
        'specialization': 'Гражданское право',
        'categories': ['Гражданское право', 'Земельное право'],
        'rating': 4.6,
        'review_count': 78,
        'price': 6000,
        'city': 'Алматы',
        'distance': 3.1,
        'is_verified': true,
        'is_online': true,
        'isActive': true,
        'experience': 7,
        'cases_won': 61,
        'about':
            'Специализируюсь на гражданских и земельных спорах. Помогаю оформить землю, решить споры с соседями, взыскать долги через суд.',
      },
      {
        'id': 'lawyer_005',
        'name': 'Тимур Жаксыбеков',
        'photo_url': null,
        'specialization': 'Бизнес право',
        'categories': ['Корпоративное право', 'Налоговое право', 'Контракты'],
        'rating': 4.9,
        'review_count': 203,
        'price': 15000,
        'city': 'Астана',
        'distance': 1.4,
        'is_verified': true,
        'is_online': true,
        'isActive': true,
        'experience': 18,
        'cases_won': 189,
        'about':
            'Партнер крупной юридической фирмы. Сопровождаю бизнес полного цикла: регистрация ТОО, налоговые споры, M&A сделки. Клиенты — более 50 компаний РК.',
      },
      {
        'id': 'lawyer_006',
        'name': 'Зарина Нурланова',
        'photo_url': null,
        'specialization': 'Недвижимость',
        'categories': ['Жилищное право', 'Гражданское право'],
        'rating': 4.7,
        'review_count': 89,
        'price': 9000,
        'city': 'Алматы',
        'distance': 2.0,
        'is_verified': true,
        'is_online': false,
        'isActive': true,
        'experience': 10,
        'cases_won': 74,
        'about':
            'Специалист по сделкам с недвижимостью. Проверка чистоты квартир, сопровождение купли-продажи, ипотечные споры, выселение арендаторов.',
      },
      {
        'id': 'lawyer_007',
        'name': 'Болат Сатыбалды',
        'photo_url': null,
        'specialization': 'Наследственное право',
        'categories': ['Гражданское право', 'Административное право'],
        'rating': 4.5,
        'review_count': 55,
        'price': 5500,
        'city': 'Шымкент',
        'distance': 4.2,
        'is_verified': false,
        'is_online': true,
        'isActive': true,
        'experience': 5,
        'cases_won': 42,
        'about':
            'Молодой опытный юрист в Шымкенте. Помогаю оформить наследство, оспорить завещание, решить споры между наследниками.',
      },
      {
        'id': 'lawyer_008',
        'name': 'Гульнара Жумадилова',
        'photo_url': null,
        'specialization': 'Страховое право',
        'categories': ['Страховое право', 'Гражданское право'],
        'rating': 4.8,
        'review_count': 112,
        'price': 8500,
        'city': 'Алматы',
        'distance': 1.8,
        'is_verified': true,
        'is_online': true,
        'isActive': true,
        'experience': 11,
        'cases_won': 99,
        'about':
            'Эксперт по страховым выплатам. Помогаю застрахованным взыскать отказные выплаты, оспорить занижение ущерба от ДТП, пожара, стихийных бедствий.',
      },
    ];
  }
}

