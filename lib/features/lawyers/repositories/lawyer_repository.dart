import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:legalhelp_kz/core/api/api_client.dart';
import 'package:legalhelp_kz/core/models/models.dart';

import 'package:legalhelp_kz/core/utils/mock_data.dart';

final lawyerRepositoryProvider = Provider<LawyerRepository>((ref) {
  return LawyerRepository(ref.watch(apiClientProvider));
});

class LawyerRepository {
  final ApiClient _apiClient;

  LawyerRepository(this._apiClient);

  Future<List<Lawyer>> getLawyers({String? category, String? sortBy}) async {
    try {
      final response = await _apiClient.get('/lawyers', queryParameters: {
        if (category != null && category != 'Все') 'category': category,
        if (sortBy != null) 'sort_by': sortBy,
      });
      return (response.data['lawyers'] as List<dynamic>)
          .map((l) => Lawyer.fromJson(l))
          .toList();
    } catch (e) {
      // Fallback to mock data for demo purposes
      return MockData.lawyers.where((l) {
        if (category == null || category == 'Все') return true;
        return l.categories.contains(category);
      }).toList();
    }
  }

  Future<Lawyer> getLawyerById(String id) async {
    final response = await _apiClient.get('/lawyers/$id');
    return Lawyer.fromJson(response.data['lawyer']);
  }

  Future<void> bookConsultation({
    required String lawyerId,
    required DateTime dateTime,
    required ConsultationType type,
    String? notes,
  }) async {
    await _apiClient.post('/bookings', data: {
      'lawyer_id': lawyerId,
      'date_time': dateTime.toIso8601String(),
      'type': type.name,
      if (notes != null) 'notes': notes,
    });
  }

  Future<List<Review>> getReviews(String lawyerId) async {
    final response = await _apiClient.get('/lawyers/$lawyerId/reviews');
    return (response.data['reviews'] as List<dynamic>)
        .map((r) => Review.fromJson(r))
        .toList();
  }
}
