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
    // We fetch all lawyers and filter/sort in memory to avoid 
    // requiring complex composite indexes in Firestore for new projects.
    return _fs.lawyersCol
        .snapshots().map((snap) {
      
      var lawyers = snap.docs.map((d) => _lawyerFromDoc(d.data())).toList();

      if (category != null && category.isNotEmpty && category != 'Все') {
        lawyers = lawyers.where((l) => l.categories.any((c) => c.contains(category))).toList();
      }
      if (city != null && city.isNotEmpty) {
        // Model doesn't expose city natively yet but if it did we'd match here.
      }

      lawyers.sort((a, b) {
        if (sort == 'rating') {
          return b.rating.compareTo(a.rating);
        } else if (sort == 'price_asc') {
          return a.price.compareTo(b.price);
        } else if (sort == 'price_desc') {
          return b.price.compareTo(a.price);
        }
        return 0; // fallback
      });

      return lawyers;
    });
  }

  /// Returns a single lawyer by ID.
  Future<Lawyer?> getLawyerById(String lawyerId) async {
    final snap = await _fs.getDoc(_fs.lawyerDoc(lawyerId));
    if (!snap.exists || snap.data() == null) return null;
    return _lawyerFromDoc(snap.data()!);
  }

  Stream<List<Review>> getReviews(String lawyerId) {
    return _fs.reviewsCol(lawyerId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) {
              final data = d.data();
              data['id'] = d.id;
              return _reviewFromDoc(data);
            }).toList());
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

  Review _reviewFromDoc(Map<String, dynamic> data) {
    return Review(
      id: data['id'] as String,
      authorName: data['author_name'] as String,
      authorAvatarUrl: data['author_avatar_url'] as String?,
      rating: (data['rating'] as num).toDouble(),
      comment: data['comment'] as String,
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
