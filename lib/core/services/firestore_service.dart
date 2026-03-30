import 'package:cloud_firestore/cloud_firestore.dart';

/// Generic Firestore service providing CRUD helpers for all collections.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── USERS ────────────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get usersCol =>
      _db.collection('users');

  DocumentReference<Map<String, dynamic>> userDoc(String uid) =>
      usersCol.doc(uid);

  // ─── CHATS ────────────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get chatsCol =>
      _db.collection('chats');

  DocumentReference<Map<String, dynamic>> chatDoc(String chatId) =>
      chatsCol.doc(chatId);

  CollectionReference<Map<String, dynamic>> messagesCol(String chatId) =>
      chatsCol.doc(chatId).collection('messages');

  // ─── LAWYERS ──────────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get lawyersCol =>
      _db.collection('lawyers');

  DocumentReference<Map<String, dynamic>> lawyerDoc(String lawyerId) =>
      lawyersCol.doc(lawyerId);

  CollectionReference<Map<String, dynamic>> reviewsCol(String lawyerId) =>
      lawyersCol.doc(lawyerId).collection('reviews');

  // ─── BOOKINGS ─────────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get bookingsCol =>
      _db.collection('bookings');

  DocumentReference<Map<String, dynamic>> bookingDoc(String bookingId) =>
      bookingsCol.doc(bookingId);

  // ─── DOCUMENTS ────────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get documentsCol =>
      _db.collection('documents');

  DocumentReference<Map<String, dynamic>> documentDoc(String docId) =>
      documentsCol.doc(docId);

  // ─── HELPERS ──────────────────────────────────────────────────────────────

  /// Creates a document, merges if already exists.
  Future<void> setDoc(
    DocumentReference<Map<String, dynamic>> ref,
    Map<String, dynamic> data, {
    bool merge = false,
  }) async {
    await ref.set(data, SetOptions(merge: merge));
  }

  /// Updates specific fields in a document.
  Future<void> updateDoc(
    DocumentReference<Map<String, dynamic>> ref,
    Map<String, dynamic> data,
  ) async {
    await ref.update(data);
  }

  /// Deletes a document.
  Future<void> deleteDoc(DocumentReference<Map<String, dynamic>> ref) async {
    await ref.delete();
  }

  /// Fetches a document once.
  Future<DocumentSnapshot<Map<String, dynamic>>> getDoc(
    DocumentReference<Map<String, dynamic>> ref,
  ) async {
    return await ref.get();
  }

  /// Returns a real-time document stream.
  Stream<DocumentSnapshot<Map<String, dynamic>>> docStream(
    DocumentReference<Map<String, dynamic>> ref,
  ) =>
      ref.snapshots();

  /// Returns a real-time collection stream.
  Stream<QuerySnapshot<Map<String, dynamic>>> collectionStream(
    CollectionReference<Map<String, dynamic>> ref,
  ) {
    return ref.snapshots();
  }

  /// Adds a new document with auto-generated ID.
  Future<DocumentReference<Map<String, dynamic>>> addDoc(
    CollectionReference<Map<String, dynamic>> col,
    Map<String, dynamic> data,
  ) async {
    return await col.add(data);
  }

  /// Server timestamp helper.
  static FieldValue get serverTimestamp => FieldValue.serverTimestamp();
}

