// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAp7VmGvH2RsG8s8UUYIM-yCaOeG86CPEM',
    appId: '1:242504343313:web:763fe06d69da5593ea36b0',
    messagingSenderId: '242504343313',
    projectId: 'syrian-hajj',
    authDomain: 'syrian-hajj.firebaseapp.com',
    storageBucket: 'syrian-hajj.appspot.com',
    measurementId: 'G-17VJVCKPV7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyArfEbMfwSJXeQEDZa7qKqgYs4Oj-FJYrQ',
    appId: '1:242504343313:android:6b7252c5a3294044ea36b0',
    messagingSenderId: '242504343313',
    projectId: 'syrian-hajj',
    storageBucket: 'syrian-hajj.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBtvcwrzuGNj6tLnuM5AWux_p-W3urAfcE',
    appId: '1:242504343313:ios:ba8db4642252a65eea36b0',
    messagingSenderId: '242504343313',
    projectId: 'syrian-hajj',
    storageBucket: 'syrian-hajj.appspot.com',
    iosClientId: '242504343313-6amrjk499fjt9khkqhfoevsug5t6ovmb.apps.googleusercontent.com',
    iosBundleId: 'com.example.syrianHajj',
  );
}
