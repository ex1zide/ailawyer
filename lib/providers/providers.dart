import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/utils/mock_data.dart';
import 'package:legalhelp_kz/features/auth/repositories/auth_repository.dart';
import 'package:legalhelp_kz/features/chat/repositories/chat_repository.dart';
import 'package:legalhelp_kz/features/lawyers/repositories/lawyer_repository.dart';
import 'package:legalhelp_kz/core/services/firestore_service.dart';
import 'package:legalhelp_kz/core/services/storage_service.dart';
import 'package:legalhelp_kz/core/services/openai_service.dart';
import 'package:legalhelp_kz/core/services/user_service.dart';
import 'package:legalhelp_kz/core/services/chat_service.dart';
import 'package:legalhelp_kz/core/services/lawyer_service.dart';
import 'package:legalhelp_kz/core/services/booking_service.dart';
import 'package:legalhelp_kz/core/services/document_service.dart';
import 'package:legalhelp_kz/core/services/news_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Global Service Instances ───────────────────────────────────────────────
final newsService = NewsService();

// ─── Auth Provider ────────────────────────────────────────────────────────────

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final User? user;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    User? user,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState()) {
    _init();
  }

  void _init() {
    _repository.authStateChanges.listen((firebaseUser) {
      if (firebaseUser != null) {
        state = state.copyWith(
          isAuthenticated: true,
          user: User(
            id: firebaseUser.uid,
            phone: firebaseUser.phoneNumber ?? '',
            firstName: firebaseUser.displayName?.split(' ').first,
            lastName: firebaseUser.displayName?.split(' ').last,
          ),
        );
      } else {
        state = const AuthState();
      }
    });
  }

  Future<void> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.sendOtp(phone);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> verifyOtp(String phone, String code) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.verifyOtp(phone, code);
      state = state.copyWith(isLoading: false, isAuthenticated: true, user: user);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> setupProfile(String firstName, String lastName) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repository.setupProfile(firstName, lastName);
      state = state.copyWith(isLoading: false, user: user, isAuthenticated: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.signIn(email, password);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.signUp(email, password);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  void setUser(User user) {
    state = state.copyWith(user: user, isAuthenticated: true);
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

// ─── Core Service Providers ───────────────────────────────────────────────────

final firestoreServiceProvider =
    Provider<FirestoreService>((ref) => FirestoreService());

final storageServiceProvider =
    Provider<StorageService>((ref) => StorageService());

final openAIServiceProvider = Provider<OpenAIService>((ref) => OpenAIService());

final userServiceProvider = Provider<UserService>((ref) {
  return UserService(
    ref.watch(firestoreServiceProvider),
    ref.watch(storageServiceProvider),
  );
});

final chatServiceProvider = Provider<ChatService>((ref) {
  return ChatService(
    ref.watch(firestoreServiceProvider),
    ref.watch(openAIServiceProvider),
  );
});

final lawyerServiceProvider = Provider<LawyerService>((ref) {
  return LawyerService(ref.watch(firestoreServiceProvider));
});

final bookingServiceProvider = Provider<BookingService>((ref) {
  return BookingService(
    ref.watch(firestoreServiceProvider),
    ref.watch(lawyerServiceProvider),
  );
});

final documentServiceProvider = Provider<DocumentService>((ref) {
  return DocumentService(
    ref.watch(firestoreServiceProvider),
    ref.watch(storageServiceProvider),
  );
});

// ─── User Profile Provider ────────────────────────────────────────────────────

final userProvider = Provider<User>((ref) {
  return ref.watch(authProvider).user ?? MockData.currentUser;
});

/// Real-time Firestore stream of the current user's profile.
final userProfileProvider = StreamProvider<User?>((ref) {
  final uid = ref.watch(authProvider).user?.id;
  if (uid == null) return const Stream.empty();
  return ref.watch(userServiceProvider).getUserStream(uid);
});


// ─── Chat Provider ────────────────────────────────────────────────────────────

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final ChatRepository _repository;

  ChatNotifier(this._repository) : super([]);

  Future<void> loadHistory() async {
    try {
      final history = await _repository.getHistory();
      state = history;
    } catch (e) {
      // SILENT_FAIL for now or handle as needed
    }
  }

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }

  Future<void> sendMessage(String text) async {
    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    addMessage(userMsg);

    final loadingMsg = ChatMessage(
      id: 'loading',
      text: '',
      isUser: false,
      timestamp: DateTime.now(),
      isLoading: true,
    );
    addMessage(loadingMsg);

    try {
      // Pass full conversation history so Gemini has context
      final history = state.where((m) => m.id != 'loading').toList();
      final aiMsg = await _repository.sendMessage(text, history: history);
      state = state.where((m) => m.id != 'loading').toList();
      addMessage(aiMsg);
    } catch (e) {
      state = state.where((m) => m.id != 'loading').toList();
      addMessage(ChatMessage(
        id: 'error_${DateTime.now().millisecondsSinceEpoch}',
        text: 'Ошибка: ${e.toString().replaceAll("Exception: ", "")}',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    }
  }
  // (Removed duplicate sendMessage block)
  Future<void> clearMessages() async {
    try {
      await _repository.clearHistory();
      state = [];
    } catch (e) {
      // SILENT_FAIL
    }
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  final notifier = ChatNotifier(repository);
  // Optional: load history on init
  // notifier.loadHistory();
  return notifier;
});



// ─── Lawyers Provider ─────────────────────────────────────────────────────────

class LawyersFilter {
  final String category;
  final String sortBy; // 'rating', 'price_asc', 'price_desc'

  const LawyersFilter({this.category = 'Все', this.sortBy = 'rating'});

  LawyersFilter copyWith({String? category, String? sortBy}) {
    return LawyersFilter(
      category: category ?? this.category,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class LawyersNotifier extends StateNotifier<LawyersFilter> {
  LawyersNotifier() : super(const LawyersFilter());

  void setCategory(String category) {
    state = state.copyWith(category: category);
  }

  void setSortBy(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }
}

final lawyersFilterProvider = StateNotifierProvider<LawyersNotifier, LawyersFilter>((ref) {
  return LawyersNotifier();
});

final lawyersProvider = StreamProvider<List<Lawyer>>((ref) {
  final filter = ref.watch(lawyersFilterProvider);
  final category = filter.category == 'Все' ? null : filter.category;
  return ref.watch(lawyerServiceProvider).getLawyers(
    category: category,
    sort: filter.sortBy == 'rating' ? 'rating' : filter.sortBy,
  );
});

final lawyerProfileProvider = FutureProvider.family<Lawyer?, String>((ref, id) {
  return ref.watch(lawyerServiceProvider).getLawyerById(id);
});

final reviewsProvider = StreamProvider.family<List<Review>, String>((ref, id) {
  return ref.watch(lawyerServiceProvider).getReviews(id);
});

// ─── Notifications Provider ───────────────────────────────────────────────────

class NotificationsNotifier extends StateNotifier<List<AppNotification>> {
  NotificationsNotifier() : super(MockData.notifications);

  void markAsRead(String id) {
    state = state.map((n) => n.id == id
        ? AppNotification(
            id: n.id,
            title: n.title,
            body: n.body,
            type: n.type,
            timestamp: n.timestamp,
            isRead: true,
          )
        : n).toList();
  }

  void markAllRead() {
    state = state.map((n) => AppNotification(
      id: n.id,
      title: n.title,
      body: n.body,
      type: n.type,
      timestamp: n.timestamp,
      isRead: true,
    )).toList();
  }

  void remove(String id) {
    state = state.where((n) => n.id != id).toList();
  }
}

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, List<AppNotification>>((ref) {
  return NotificationsNotifier();
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).where((n) => !n.isRead).length;
});

/// Real-time Firestore stream of the current user's documents.
final documentsProvider = StreamProvider<List<Document>>((ref) {
  final uid = ref.watch(authProvider).user?.id;
  if (uid == null) return Stream.value([]);
  return ref.watch(documentServiceProvider).getUserDocuments(uid);
});

/// Real-time Firestore stream of the current user's bookings.
final bookingsProvider = StreamProvider<List<Booking>>((ref) {
  final uid = ref.watch(authProvider).user?.id;
  if (uid == null) return Stream.value([]);
  return ref.watch(bookingServiceProvider).getUserBookings(uid);
});

// ─── News Provider ────────────────────────────────────────────────────────────

final newsProvider = FutureProvider<List<LegalNews>>((ref) async {
  return await newsService.fetchRealNews();
});

// ─── Saved Lawyers Provider ───────────────────────────────────────────────────

class SavedLawyersNotifier extends StateNotifier<List<String>> {
  SavedLawyersNotifier() : super(['l001', 'l003', 'l006']);

  void toggle(String lawyerId) {
    if (state.contains(lawyerId)) {
      state = state.where((id) => id != lawyerId).toList();
    } else {
      state = [...state, lawyerId];
    }
  }

  bool isSaved(String lawyerId) => state.contains(lawyerId);
}

final savedLawyersProvider = StateNotifierProvider<SavedLawyersNotifier, List<String>>((ref) {
  return SavedLawyersNotifier();
});

// ─── App Settings Provider ────────────────────────────────────────────────────

class AppSettings {
  final bool pushNotifications;
  final bool emailNotifications;
  final String language;
  final bool biometricAuth;

  const AppSettings({
    this.pushNotifications = true,
    this.emailNotifications = false,
    this.language = 'ru',
    this.biometricAuth = false,
  });

  AppSettings copyWith({
    bool? pushNotifications,
    bool? emailNotifications,
    String? language,
    bool? biometricAuth,
  }) {
    return AppSettings(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      language: language ?? this.language,
      biometricAuth: biometricAuth ?? this.biometricAuth,
    );
  }
}

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(const AppSettings());

  void togglePushNotifications() {
    state = state.copyWith(pushNotifications: !state.pushNotifications);
  }

  void toggleEmailNotifications() {
    state = state.copyWith(emailNotifications: !state.emailNotifications);
  }

  void setLanguage(String lang) {
    state = state.copyWith(language: lang);
  }

  void toggleBiometric() {
    state = state.copyWith(biometricAuth: !state.biometricAuth);
  }
}

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});

// ─── Search Provider ──────────────────────────────────────────────────────────

class SearchNotifier extends StateNotifier<String> {
  SearchNotifier() : super('');

  void setQuery(String q) => state = q;
  void clear() => state = '';
}

final searchQueryProvider = StateNotifierProvider<SearchNotifier, String>((ref) {
  return SearchNotifier();
});

// ─── Language Provider ────────────────────────────────────────────────────────

class LanguageNotifier extends StateNotifier<String> {
  final SharedPreferences _prefs;
  static const _key = 'app_language';

  LanguageNotifier(this._prefs) : super(_prefs.getString(_key) ?? 'Русский');

  Future<void> setLanguage(String lang) async {
    state = lang;
    await _prefs.setString(_key, lang);
  }
  
  void toggle() {
    setLanguage(state == 'Русский' ? 'Қазақша' : 'Русский');
  }
}

// Ensure SharedPreferences is initialized before running the app
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier(ref.watch(sharedPreferencesProvider));
});
