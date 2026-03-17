import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/services/firestore_service.dart';
import 'package:legalhelp_kz/core/services/storage_service.dart';

/// Handles all Firestore operations for user profiles.
class UserService {
  final FirestoreService _fs;
  final StorageService _storage;

  UserService(this._fs, this._storage);

  /// Creates a new user profile in Firestore after registration.
  Future<void> createUserProfile(
    String uid, {
    String? email,
    String? phone,
    String? firstName,
    String? lastName,
  }) async {
    final data = {
      'id': uid,
      'email': email,
      'phone': phone ?? '',
      'first_name': firstName,
      'last_name': lastName,
      'avatar_url': null,
      'city': 'Алматы',
      'language': 'ru',
      'interests': <String>[],
      'plan': 'free',
      'questions_asked': 0,
      'documents_scanned': 0,
      'lawyers_contacted': 0,
      'created_at': FirestoreService.serverTimestamp,
    };
    await _fs.setDoc(_fs.userDoc(uid), data, merge: true);
  }

  /// Returns a real-time stream of the user profile.
  Stream<User?> getUserStream(String uid) {
    return _fs.docStream(_fs.userDoc(uid)).map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return User.fromJson(snap.data()!);
    });
  }

  /// Fetches the user profile once.
  Future<User?> getUser(String uid) async {
    final snap = await _fs.getDoc(_fs.userDoc(uid));
    if (!snap.exists || snap.data() == null) return null;
    return User.fromJson(snap.data()!);
  }

  /// Updates user profile fields.
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _fs.updateDoc(_fs.userDoc(uid), {
      ...data,
      'updated_at': FirestoreService.serverTimestamp,
    });
  }

  /// Uploads an avatar image and updates the profile with the URL.
  Future<String> uploadAvatar(String uid, File file) async {
    final url = await _storage.uploadAvatar(uid, file);
    await _fs.updateDoc(_fs.userDoc(uid), {'avatar_url': url});
    return url;
  }

  /// Increments a counter field (e.g., questionsAsked, documentsScanned).
  Future<void> incrementCounter(String uid, String field) async {
    await _fs.updateDoc(_fs.userDoc(uid), {
      field: FieldValue.increment(1),
    });
  }
}
