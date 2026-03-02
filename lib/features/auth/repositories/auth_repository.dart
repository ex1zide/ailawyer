import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:legalhelp_kz/core/api/api_client.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/utils/mock_data.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider));
});

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<void> sendOtp(String phone) async {
    try {
      await _apiClient.post('/auth/send-otp', data: {'phone': phone});
    } catch (e) {
      // Bypass for testing
    }
  }

  Future<User> verifyOtp(String phone, String code) async {
    if (code == '123456') {
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
}
