import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:legalhelp_kz/core/api/api_client.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/utils/mock_data.dart';
import 'package:legalhelp_kz/core/auth/auth_service.dart';
import 'package:legalhelp_kz/core/services/user_service.dart';
import 'package:legalhelp_kz/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

final authServiceProvider = Provider((ref) => AuthService());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(apiClientProvider),
    ref.watch(authServiceProvider),
    ref.watch(userServiceProvider),
  );
});

class AuthRepository {
  final ApiClient _apiClient;
  final AuthService _authService;
  final UserService _userService;

  AuthRepository(this._apiClient, this._authService, this._userService);

  Stream<firebase.User?> get authStateChanges => _authService.authStateChanges;

  Future<void> sendOtp(String phone) async {
    try {
      await _apiClient.post('/auth/send-otp', data: {'phone': phone});
    } catch (e) {
      // Bypass for testing
    }
  }

  Future<User> verifyOtp(String phone, String code) async {
    // Debug-only OTP bypass for testing
    if (kDebugMode && code == '123456') {
      return MockData.currentUser;
    }
    final response = await _apiClient.post('/auth/verify-otp', data: {
      'phone': phone,
      'code': code,
    });
    return User.fromJson(response.data['user']);
  }

  Future<User> setupProfile(String firstName, String lastName) async {
    final response = await _apiClient.post('/auth/setup-profile', data: {
      'first_name': firstName,
      'last_name': lastName,
    });
    return User.fromJson(response.data['user']);
  }

  Future<firebase.UserCredential> signIn(String email, String password) async {
    return await _authService.signIn(email, password);
  }

  /// Signs up and auto-creates a Firestore user profile.
  Future<firebase.UserCredential> signUp(String email, String password) async {
    final credential = await _authService.signUp(email, password);
    final uid = credential.user?.uid;
    if (uid != null) {
      await _userService.createUserProfile(
        uid,
        email: email,
      );
    }
    return credential;
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}

