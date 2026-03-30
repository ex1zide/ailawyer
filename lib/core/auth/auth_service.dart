import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart';

class AuthService {
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;

  // Stream of auth state changes
  Stream<firebase.User?> get authStateChanges => _auth.authStateChanges();

  // Sign Up with Email and Password
  Future<firebase.UserCredential> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase.FirebaseAuthException catch (e) {
      _handleAuthError(e);
      rethrow;
    }
  }

  // Sign In with Email and Password
  Future<firebase.UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase.FirebaseAuthException catch (e) {
      _handleAuthError(e);
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Error handling
  void _handleAuthError(firebase.FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'Пользователь не найден. Проверьте email или зарегистрируйтесь.';
        break;
      case 'wrong-password':
        message = 'Неверный пароль. Попробуйте еще раз.';
        break;
      case 'email-already-in-use':
        message = 'Этот email уже используется другим пользователем.';
        break;
      case 'invalid-email':
        message = 'Неверный формат email.';
        break;
      case 'weak-password':
        message = 'Пароль слишком слабый. Минимум 6 символов.';
        break;
      case 'network-request-failed':
        message = 'Ошибка сети. Проверьте подключение к интернету.';
        break;
      default:
        message = 'Произошла ошибка: ${e.message}';
    }
    throw Exception(message);
  }
}

