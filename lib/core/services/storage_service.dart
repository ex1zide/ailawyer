import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Handles file uploads and downloads via Firebase Storage.
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file to [path] and returns the download URL.
  Future<String> uploadFile(String storagePath, File file) async {
    final ref = _storage.ref().child(storagePath);
    final task = await ref.putFile(file);
    return await task.ref.getDownloadURL();
  }

  /// Uploads bytes (for web) to [path] and returns the download URL.
  Future<String> uploadBytes(String storagePath, Uint8List bytes,
      {String contentType = 'application/octet-stream'}) async {
    final ref = _storage.ref().child(storagePath);
    final metadata = SettableMetadata(contentType: contentType);
    final task = await ref.putData(bytes, metadata);
    return await task.ref.getDownloadURL();
  }

  /// Uploads a user avatar and returns the download URL.
  /// [uid] — Firebase user ID.
  /// [file] — image file to upload.
  Future<String> uploadAvatar(String uid, File file) async {
    final extension = file.path.split('.').last;
    final path = 'avatars/$uid/avatar.$extension';
    return await uploadFile(path, file);
  }

  /// Uploads a document for the user and returns the download URL.
  Future<String> uploadDocument(String uid, String docId, File file) async {
    final extension = file.path.split('.').last;
    final path = 'documents/$uid/$docId.$extension';
    return await uploadFile(path, file);
  }

  /// Deletes a file at [storagePath].
  Future<void> deleteFile(String storagePath) async {
    await _storage.ref().child(storagePath).delete();
  }

  /// Returns a download URL for a given [storagePath].
  Future<String> getDownloadUrl(String storagePath) async {
    return await _storage.ref().child(storagePath).getDownloadURL();
  }
}

