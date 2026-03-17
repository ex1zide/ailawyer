import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/services/firestore_service.dart';

/// Handles Firestore operations for lawyers and their reviews.
class LawyerService {
  final FirestoreService _fs;
  final _uuid = const Uuid();

  LawyerService(this._fs);

  // ─── Lawyers ──────────────────────────────────────────────────────────────

  /// Returns a stream of all lawyers, optionally filtered.
  Stream<List<Lawyer>> getLawyers({
    String? category,
    String? city,
    String sort = 'rating', // 'rating' | 'price' | 'experience'
  }) {
    Query<Map<String, dynamic>> query = _fs.lawyersCol
        .where('isActive', isEqualTo: true);

    if (category != null && category.isNotEmpty) {
      query = query.where('categories', arrayContains: category);
    }
    if (city != null && city.isNotEmpty) {
      query = query.where('city', isEqualTo: city);
    }

    query = query.orderBy(sort, descending: true);

    return query.snapshots().map((snap) =>
        snap.docs.map((d) => _lawyerFromDoc(d.data())).toList());
  }

  /// Returns a single lawyer by ID.
  Future<Lawyer?> getLawyerById(String lawyerId) async {
    final snap = await _fs.getDoc(_fs.lawyerDoc(lawyerId));
    if (!snap.exists || snap.data() == null) return null;
    return _lawyerFromDoc(snap.data()!);
  }

  /// Returns a stream of a lawyer's reviews.
  Stream<List<Review>> getReviews(String lawyerId) {
    return _fs.reviewsCol(lawyerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => Review.fromJson(d.data()))
            .toList());
  }

  /// Adds a review for a lawyer and updates their average rating.
  Future<void> addReview(
    String lawyerId,
    String authorId,
    String authorName,
    double rating,
    String comment,
  ) async {
    final reviewId = _uuid.v4();
    await _fs.setDoc(
      _fs.reviewsCol(lawyerId).doc(reviewId),
      {
        'id': reviewId,
        'author_id': authorId,
        'author_name': authorName,
        'rating': rating,
        'comment': comment,
        'created_at': FirestoreService.serverTimestamp,
      },
    );

    // Recalculate average rating
    final reviews = await _fs.reviewsCol(lawyerId).get();
    final totalRating = reviews.docs.fold<double>(
        0, (sum, d) => sum + (d.data()['rating'] as num).toDouble());
    final avgRating =
        reviews.docs.isEmpty ? rating : totalRating / reviews.docs.length;

    await _fs.updateDoc(_fs.lawyerDoc(lawyerId), {
      'rating': double.parse(avgRating.toStringAsFixed(1)),
      'review_count': reviews.docs.length,
    });
  }

  // ─── Private ──────────────────────────────────────────────────────────────

  Lawyer _lawyerFromDoc(Map<String, dynamic> data) {
    return Lawyer(
      id: data['id'] as String,
      name: data['name'] as String,
      photoUrl: data['photo_url'] as String?,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: data['review_count'] as int? ?? 0,
      specialization: data['specialization'] as String? ?? '',
      categories: (data['categories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      distance: (data['distance'] as num?)?.toDouble() ?? 0.0,
      price: data['price'] as int? ?? 0,
      isVerified: data['is_verified'] as bool? ?? false,
      isOnline: data['is_online'] as bool? ?? false,
      about: data['about'] as String?,
      experience: data['experience'] as int? ?? 0,
      casesWon: data['cases_won'] as int? ?? 0,
    );
  }
}
