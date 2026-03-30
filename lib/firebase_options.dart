import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB22Q7WHX_eMvVHaPFZVsmN7UhePfhSqCY',
    authDomain: 'legalhelp-kz.firebaseapp.com',
    projectId: 'legalhelp-kz',
    storageBucket: 'legalhelp-kz.firebasestorage.app',
    messagingSenderId: '109408977432',
    appId: '1:109408977432:web:REPLACE_WITH_WEB_APP_ID',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB22Q7WHX_eMvVHaPFZVsmN7UhePfhSqCY',
    appId: '1:109408977432:android:36469c8268028a9ac6b96d',
    messagingSenderId: '109408977432',
    projectId: 'legalhelp-kz',
    storageBucket: 'legalhelp-kz.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBBu_RUoTgLGrFZO4oiBceFT_sZA8P1vL8',
    appId: '1:109408977432:ios:7867bfca6e6372e8c6b96d',
    messagingSenderId: '109408977432',
    projectId: 'legalhelp-kz',
    storageBucket: 'legalhelp-kz.firebasestorage.app',
    iosBundleId: 'com.example.legalhelpKz',
  );
}

