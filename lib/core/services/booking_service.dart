import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/services/firestore_service.dart';
import 'package:legalhelp_kz/core/services/lawyer_service.dart';

/// Handles Firestore operations for user bookings (consultation appointments).
class BookingService {
  final FirestoreService _fs;
  final LawyerService _lawyerService;
  final _uuid = const Uuid();

  BookingService(this._fs, this._lawyerService);

  /// Creates a new booking and returns its ID.
  Future<String> createBooking({
    required String userId,
    required String lawyerId,
    required DateTime dateTime,
    required ConsultationType type,
    required int price,
    String? notes,
  }) async {
    final bookingId = _uuid.v4();
    await _fs.setDoc(_fs.bookingDoc(bookingId), {
      'id': bookingId,
      'userId': userId,
      'lawyerId': lawyerId,
      'dateTime': Timestamp.fromDate(dateTime),
      'type': _typeToString(type),
      'status': 'upcoming',
      'price': price,
      'notes': notes,
      'createdAt': FirestoreService.serverTimestamp,
    });
    return bookingId;
  }

  /// Returns a real-time stream of all bookings for a user.
  Stream<List<Booking>> getUserBookings(String userId) {
    return _fs.bookingsCol
        .where('userId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snap) async {
      final bookings = <Booking>[];
      // Cache lawyers to avoid N+1 queries
      final lawyerCache = <String, Lawyer>{};
      for (final doc in snap.docs) {
        final data = doc.data();
        final lawyerId = data['lawyerId'] as String;
        if (!lawyerCache.containsKey(lawyerId)) {
          final lawyer = await _lawyerService.getLawyerById(lawyerId);
          if (lawyer != null) lawyerCache[lawyerId] = lawyer;
        }
        final lawyer = lawyerCache[lawyerId];
        if (lawyer != null) {
          bookings.add(_bookingFromDoc(data, lawyer));
        }
      }
      // Sort locally descending by date
      bookings.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      return bookings;
    });
  }

  /// Cancels a booking.
  Future<void> cancelBooking(String bookingId) async {
    await _fs.updateDoc(_fs.bookingDoc(bookingId), {'status': 'cancelled'});
  }

  /// Marks a booking as completed.
  Future<void> completeBooking(String bookingId) async {
    await _fs.updateDoc(_fs.bookingDoc(bookingId), {'status': 'completed'});
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Booking _bookingFromDoc(Map<String, dynamic> data, Lawyer lawyer) {
    return Booking(
      id: data['id'] as String,
      lawyer: lawyer,
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      type: _typeFromString(data['type'] as String),
      status: _statusFromString(data['status'] as String),
      price: data['price'] as int,
      notes: data['notes'] as String?,
    );
  }

  String _typeToString(ConsultationType type) {
    switch (type) {
      case ConsultationType.online:
        return 'online';
      case ConsultationType.phone:
        return 'phone';
      case ConsultationType.inPerson:
        return 'inPerson';
    }
  }

  ConsultationType _typeFromString(String type) {
    switch (type) {
      case 'phone':
        return ConsultationType.phone;
      case 'inPerson':
        return ConsultationType.inPerson;
      default:
        return ConsultationType.online;
    }
  }

  BookingStatus _statusFromString(String status) {
    switch (status) {
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.upcoming;
    }
  }
}

