// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBkUDvzd-YxoB_nNl9W1h4JqX-nx-_ZZ7U',
    appId: '1:1006388502742:web:ef880812c611feeacda977',
    messagingSenderId: '1006388502742',
    projectId: 'recipeme-c11db',
    authDomain: 'recipeme-c11db.firebaseapp.com',
    storageBucket: 'recipeme-c11db.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDh6VCzQR31vqDiv3rBd6qmYc42NM9Xq8M',
    appId: '1:1006388502742:android:93b328f0aea2eb82cda977',
    messagingSenderId: '1006388502742',
    projectId: 'recipeme-c11db',
    storageBucket: 'recipeme-c11db.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAHWXdaGg2dG7qVcTFa7JzTqkF8_pCI1Vk',
    appId: '1:1006388502742:ios:aa5630308ab13ec7cda977',
    messagingSenderId: '1006388502742',
    projectId: 'recipeme-c11db',
    storageBucket: 'recipeme-c11db.firebasestorage.app',
    iosBundleId: 'com.abhi.recipemeApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAHWXdaGg2dG7qVcTFa7JzTqkF8_pCI1Vk',
    appId: '1:1006388502742:ios:aa5630308ab13ec7cda977',
    messagingSenderId: '1006388502742',
    projectId: 'recipeme-c11db',
    storageBucket: 'recipeme-c11db.firebasestorage.app',
    iosBundleId: 'com.abhi.recipemeApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBkUDvzd-YxoB_nNl9W1h4JqX-nx-_ZZ7U',
    appId: '1:1006388502742:web:da992f441d27ce16cda977',
    messagingSenderId: '1006388502742',
    projectId: 'recipeme-c11db',
    authDomain: 'recipeme-c11db.firebaseapp.com',
    storageBucket: 'recipeme-c11db.firebasestorage.app',
  );
}
