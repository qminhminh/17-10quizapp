// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDiY-70EJHV_uAsDHeyqSXMEc60N7flxZQ',
    appId: '1:306452440637:web:1c1ae351c5af223fb42c54',
    messagingSenderId: '306452440637',
    projectId: 'thutext-2f1a9',
    authDomain: 'thutext-2f1a9.firebaseapp.com',
    storageBucket: 'thutext-2f1a9.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwj9730uqk0MoesrFSCydIRc5TgaO0m5M',
    appId: '1:306452440637:android:bd4dd71b167a9aa3b42c54',
    messagingSenderId: '306452440637',
    projectId: 'thutext-2f1a9',
    storageBucket: 'thutext-2f1a9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBMIxHxxTBgc1pTk90kpkpg4zja0jVzm6A',
    appId: '1:306452440637:ios:b4188ae2b1cf2d25b42c54',
    messagingSenderId: '306452440637',
    projectId: 'thutext-2f1a9',
    storageBucket: 'thutext-2f1a9.appspot.com',
    iosBundleId: 'com.example.thutext',
  );
}