import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:legalhelp_kz/core/models/models.dart';
import 'package:legalhelp_kz/core/services/firestore_service.dart';
import 'package:legalhelp_kz/core/services/storage_service.dart';
import 'package:uuid/uuid.dart';

/// Handles Firestore + Storage operations for user documents.
class DocumentService {
  final FirestoreService _fs;
  final StorageService _storage;
  final _uuid = const Uuid();

  DocumentService(this._fs, this._storage);

  /// Uploads a document file and saves metadata to Firestore.
  Future<Document> uploadDocument({
    required String userId,
    required File file,
    required String name,
    required String type,
    String? extractedText,
  }) async {
    final docId = _uuid.v4();
    final fileSize = await file.length();

    // Upload file to Firebase Storage
    final storageUrl = await _storage.uploadDocument(userId, docId, file);

    final doc = Document(
      id: docId,
      name: name,
      type: type,
      createdAt: DateTime.now(),
      extractedText: extractedText,
      size: fileSize,
    );

    // Save metadata to Firestore
    await _fs.setDoc(_fs.documentDoc(docId), {
      'id': docId,
      'userId': userId,
      'name': name,
      'type': type,
      'storage_url': storageUrl,
      'extracted_text': extractedText,
      'size': fileSize,
      'created_at': FirestoreService.serverTimestamp,
    });

    return doc;
  }

  /// Saves a document with only extracted text (no file, e.g., after OCR).
  Future<Document> saveTextDocument({
    required String userId,
    required String name,
    required String extractedText,
    String type = 'text',
  }) async {
    final docId = _uuid.v4();

    final doc = Document(
      id: docId,
      name: name,
      type: type,
      createdAt: DateTime.now(),
      extractedText: extractedText,
      size: extractedText.length,
    );

    await _fs.setDoc(_fs.documentDoc(docId), {
      'id': docId,
      'userId': userId,
      'name': name,
      'type': type,
      'storage_url': null,
      'extracted_text': extractedText,
      'size': extractedText.length,
      'created_at': FirestoreService.serverTimestamp,
    });

    return doc;
  }

  /// Returns a real-time stream of all documents for a user.
  Stream<List<Document>> getUserDocuments(String userId) {
    return _fs.documentsCol
        .where('userId', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => _documentFromDoc(d.data())).toList());
  }

  /// Updates the extracted text for a document.
  Future<void> updateExtractedText(String docId, String text) async {
    await _fs.updateDoc(_fs.documentDoc(docId), {'extracted_text': text});
  }

  /// Deletes a document and its storage file.
  Future<void> deleteDocument(String docId, String userId) async {
    // Try to delete from storage (if file exists)
    try {
      await _storage.deleteFile('documents/$userId/$docId');
    } catch (_) {
      // File might not exist (text-only documents)
    }
    await _fs.deleteDoc(_fs.documentDoc(docId));
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Document _documentFromDoc(Map<String, dynamic> data) {
    return Document(
      id: data['id'] as String,
      name: data['name'] as String,
      type: data['type'] as String,
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      thumbnailUrl: data['storage_url'] as String?,
      extractedText: data['extracted_text'] as String?,
      size: data['size'] as int? ?? 0,
    );
  }
}
