import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/utils/mock_data.dart';
import 'package:legalhelp_kz/features/auth/repositories/auth_repository.dart';
import 'package:legalhelp_kz/features/chat/repositories/chat_repository.dart';
import 'package:legalhelp_kz/features/lawyers/repositories/lawyer_repository.dart';

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

  AuthNotifier(this._repository) : super(const AuthState());

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

  void setUser(User user) {
    state = state.copyWith(user: user, isAuthenticated: true);
  }

  void signOut() {
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

// ─── User Provider ────────────────────────────────────────────────────────────

final userProvider = Provider<User>((ref) {
  return ref.watch(authProvider).user ?? MockData.currentUser;
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
      final aiMsg = await _repository.sendMessage(text);
      state = state.where((m) => m.id != 'loading').toList();
      addMessage(aiMsg);
    } catch (e) {
      state = state.where((m) => m.id != 'loading').toList();
      addMessage(ChatMessage(
        id: 'error',
        text: 'К сожалению, произошла ошибка подключения к AI. Попробуйте позже.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    }
  }

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

final lawyersProvider = FutureProvider<List<Lawyer>>((ref) async {
  final filter = ref.watch(lawyersFilterProvider);
  try {
    return await ref.watch(lawyerRepositoryProvider).getLawyers(
      category: filter.category,
      sortBy: filter.sortBy,
    );
  } catch (e) {
    return MockData.lawyers.where((l) {
      if (filter.category == 'Все') return true;
      return l.category == filter.category;
    }).toList();
  }
});

final lawyerProfileProvider = FutureProvider.family<Lawyer, String>((ref, id) {
  return ref.watch(lawyerRepositoryProvider).getLawyerById(id);
});

final reviewsProvider = FutureProvider.family<List<Review>, String>((ref, id) {
  return ref.watch(lawyerRepositoryProvider).getReviews(id);
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

// ─── Documents Provider ───────────────────────────────────────────────────────

class DocumentsNotifier extends StateNotifier<List<Document>> {
  DocumentsNotifier() : super(MockData.documents);

  void addDocument(Document doc) {
    state = [doc, ...state];
  }

  void removeDocument(String id) {
    state = state.where((d) => d.id != id).toList();
  }
}

final documentsProvider = StateNotifierProvider<DocumentsNotifier, List<Document>>((ref) {
  return DocumentsNotifier();
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
