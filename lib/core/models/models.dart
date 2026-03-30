import 'package:flutter/material.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum SubscriptionPlan { free, pro }

enum ConsultationType { online, phone, inPerson }

enum BookingStatus { upcoming, completed, cancelled }

enum NotificationType { system, booking, chat, promo }

enum DocumentType { all, contracts, court, personal }

// ─── User ─────────────────────────────────────────────────────────────────────

class User {
  final String id;
  final String phone;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final String city;
  final String language;
  final List<String> interests;
  final SubscriptionPlan plan;
  final int questionsAsked;
  final int documentsScanned;
  final int lawyersContacted;

  const User({
    required this.id,
    required this.phone,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.city = 'Алматы',
    this.language = 'ru',
    this.interests = const [],
    this.plan = SubscriptionPlan.free,
    this.questionsAsked = 0,
    this.documentsScanned = 0,
    this.lawyersContacted = 0,
  });

  String get fullName {
    final hasFirst = firstName != null && firstName!.trim().isNotEmpty;
    final hasLast = lastName != null && lastName!.trim().isNotEmpty;
    
    if (hasFirst && hasLast) return '${firstName!.trim()} ${lastName!.trim()}';
    if (hasFirst) return firstName!.trim();
    if (hasLast) return lastName!.trim();
    if (phone.trim().isNotEmpty) return phone;
    return 'Пользователь';
  }

  User copyWith({
    String? id,
    String? phone,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    String? city,
    String? language,
    List<String>? interests,
    SubscriptionPlan? plan,
    int? questionsAsked,
    int? documentsScanned,
    int? lawyersContacted,
  }) {
    return User(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      city: city ?? this.city,
      language: language ?? this.language,
      interests: interests ?? this.interests,
      plan: plan ?? this.plan,
      questionsAsked: questionsAsked ?? this.questionsAsked,
      documentsScanned: documentsScanned ?? this.documentsScanned,
      lawyersContacted: lawyersContacted ?? this.lawyersContacted,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      phone: json['phone'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      city: json['city'] as String? ?? 'Алматы',
      language: json['language'] as String? ?? 'ru',
      interests: (json['interests'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      plan: json['plan'] == 'pro' ? SubscriptionPlan.pro : SubscriptionPlan.free,
      questionsAsked: json['questions_asked'] as int? ?? 0,
      documentsScanned: json['documents_scanned'] as int? ?? 0,
      lawyersContacted: json['lawyers_contacted'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'avatar_url': avatarUrl,
      'city': city,
      'language': language,
      'interests': interests,
      'plan': plan == SubscriptionPlan.pro ? 'pro' : 'free',
      'questions_asked': questionsAsked,
      'documents_scanned': documentsScanned,
      'lawyers_contacted': lawyersContacted,
    };
  }
}

// ─── Lawyer ───────────────────────────────────────────────────────────────────

class Lawyer {
  final String id;
  final String name;
  final String? photoUrl;
  final double rating;
  final int reviewCount;
  final String specialization;
  final List<String> categories;
  final double distance;
  final int price;
  final bool isVerified;
  final bool isOnline;
  final String? about;
  final int experience;
  final int casesWon;

  const Lawyer({
    required this.id,
    required this.name,
    this.photoUrl,
    required this.rating,
    required this.reviewCount,
    required this.specialization,
    this.categories = const [],
    required this.distance,
    required this.price,
    this.isVerified = false,
    this.isOnline = false,
    this.about,
    this.experience = 0,
    this.casesWon = 0,
  });

  factory Lawyer.fromJson(Map<String, dynamic> json) {
    return Lawyer(
      id: json['id'] as String,
      name: json['name'] as String,
      photoUrl: json['photo_url'] as String?,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] as int,
      specialization: json['specialization'] as String,
      categories: (json['categories'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      distance: (json['distance'] as num).toDouble(),
      price: json['price'] as int,
      isVerified: json['is_verified'] as bool? ?? false,
      isOnline: json['is_online'] as bool? ?? false,
      about: json['about'] as String?,
      experience: json['experience'] as int? ?? 0,
      casesWon: json['cases_won'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo_url': photoUrl,
      'rating': rating,
      'review_count': reviewCount,
      'specialization': specialization,
      'categories': categories,
      'distance': distance,
      'price': price,
      'is_verified': isVerified,
      'is_online': isOnline,
      'about': about,
      'experience': experience,
      'cases_won': casesWon,
    };
  }
}

// ─── Category ─────────────────────────────────────────────────────────────────

class Category {
  final String id;
  final String name;
  final String icon;
  final Color color;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

// ─── ChatMessage ──────────────────────────────────────────────────────────────

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? sources;
  final bool isLoading;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.sources,
    this.isLoading = false,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    List<String>? sources,
    bool? isLoading,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      sources: sources ?? this.sources,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      text: json['text'] as String,
      isUser: json['is_user'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      sources: (json['sources'] as List<dynamic>?)?.map((e) => e as String).toList(),
      isLoading: json['is_loading'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'is_user': isUser,
      'timestamp': timestamp.toIso8601String(),
      'sources': sources,
      'is_loading': isLoading,
    };
  }
}

// ─── Document ─────────────────────────────────────────────────────────────────

class Document {
  final String id;
  final String name;
  final String type;
  final DateTime createdAt;
  final String? thumbnailUrl;
  final String? extractedText;
  final int size;

  const Document({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    this.thumbnailUrl,
    this.extractedText,
    this.size = 0,
  });
}

// ─── Booking ──────────────────────────────────────────────────────────────────

class Booking {
  final String id;
  final Lawyer lawyer;
  final DateTime dateTime;
  final ConsultationType type;
  final BookingStatus status;
  final int price;
  final String? notes;

  const Booking({
    required this.id,
    required this.lawyer,
    required this.dateTime,
    required this.type,
    required this.status,
    required this.price,
    this.notes,
  });

  String get typeLabel {
    switch (type) {
      case ConsultationType.online:
        return 'Онлайн';
      case ConsultationType.phone:
        return 'По телефону';
      case ConsultationType.inPerson:
        return 'Очно';
    }
  }

  String get statusLabel {
    switch (status) {
      case BookingStatus.upcoming:
        return 'Предстоящая';
      case BookingStatus.completed:
        return 'Завершена';
      case BookingStatus.cancelled:
        return 'Отменена';
    }
  }
}

// ─── Notification ─────────────────────────────────────────────────────────────

class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });
}

// ─── News ─────────────────────────────────────────────────────────────────────

class LegalNews {
  final String id;
  final String title;
  final String summary;
  final String category;
  final DateTime publishedAt;
  final String? imageUrl;
  final String source;
  final String? url;

  const LegalNews({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.publishedAt,
    this.imageUrl,
    required this.source,
    this.url,
  });
}

// ─── Review ───────────────────────────────────────────────────────────────────

class Review {
  final String id;
  final String authorName;
  final String? authorAvatarUrl;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.authorName,
    this.authorAvatarUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      authorName: json['author_name'] as String,
      authorAvatarUrl: json['author_avatar_url'] as String?,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_name': authorName,
      'author_avatar_url': authorAvatarUrl,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// ─── EmergencyContact ─────────────────────────────────────────────────────────

class EmergencyContact {
  final String id;
  final String name;
  final String phone;
  final String description;
  final bool isAvailable24h;
  final String? icon;

  const EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
    required this.description,
    this.isAvailable24h = false,
    this.icon,
  });
}

// ─── Payment Method ───────────────────────────────────────────────────────────

class PaymentMethod {
  final String id;
  final String name;
  final String maskedNumber;
  final String type; // 'card', 'kaspi', 'halyk'
  final bool isDefault;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.maskedNumber,
    required this.type,
    this.isDefault = false,
  });
}

