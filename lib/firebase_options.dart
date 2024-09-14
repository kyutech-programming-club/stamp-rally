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
    apiKey: 'AIzaSyCfzilPz4Enpg8M2A1f4tYB8YiTI--ifc4',
    appId: '1:481583997229:web:3f9d4a7b807c6745d0b3a4',
    messagingSenderId: '481583997229',
    projectId: 'proken-stamp-rally-48913',
    authDomain: 'proken-stamp-rally-48913.firebaseapp.com',
    storageBucket: 'proken-stamp-rally-48913.appspot.com',
    measurementId: 'G-8PFHGVXQYX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCTb9RJwV09-s4zSjEwndRB5v9dZmBshws',
    appId: '1:481583997229:android:a964d68f914747b2d0b3a4',
    messagingSenderId: '481583997229',
    projectId: 'proken-stamp-rally-48913',
    storageBucket: 'proken-stamp-rally-48913.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAYr7A_HZktuFePlc8tLyV6dZQZym4td5s',
    appId: '1:481583997229:ios:caf469202a3133f1d0b3a4',
    messagingSenderId: '481583997229',
    projectId: 'proken-stamp-rally-48913',
    storageBucket: 'proken-stamp-rally-48913.appspot.com',
    iosBundleId: 'com.example.prokenStampRally',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAYr7A_HZktuFePlc8tLyV6dZQZym4td5s',
    appId: '1:481583997229:ios:caf469202a3133f1d0b3a4',
    messagingSenderId: '481583997229',
    projectId: 'proken-stamp-rally-48913',
    storageBucket: 'proken-stamp-rally-48913.appspot.com',
    iosBundleId: 'com.example.prokenStampRally',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCfzilPz4Enpg8M2A1f4tYB8YiTI--ifc4',
    appId: '1:481583997229:web:62a37779ac112520d0b3a4',
    messagingSenderId: '481583997229',
    projectId: 'proken-stamp-rally-48913',
    authDomain: 'proken-stamp-rally-48913.firebaseapp.com',
    storageBucket: 'proken-stamp-rally-48913.appspot.com',
    measurementId: 'G-B9FJ5E09KK',
  );

}