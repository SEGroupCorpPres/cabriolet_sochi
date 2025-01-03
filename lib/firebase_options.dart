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
    apiKey: 'AIzaSyCRXLMVs87HlfSif71Ipp_OzjoHJfeIqio',
    appId: '1:795491107509:web:5ec2a4c75773c45600b4fc',
    messagingSenderId: '795491107509',
    projectId: 'cabrioletsochi-77196',
    authDomain: 'cabrioletsochi-77196.firebaseapp.com',
    storageBucket: 'cabrioletsochi-77196.appspot.com',
    measurementId: 'G-WNM658NLGS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKOd_ze6wzmGD1pQDaMCTZ-P-QzWA-5lY',
    appId: '1:795491107509:android:6b614557a21883c200b4fc',
    messagingSenderId: '795491107509',
    projectId: 'cabrioletsochi-77196',
    storageBucket: 'cabrioletsochi-77196.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAl8GG24LwJk6RZvaso-54NkbBKY4IRTDU',
    appId: '1:795491107509:ios:62b766789c48be1100b4fc',
    messagingSenderId: '795491107509',
    projectId: 'cabrioletsochi-77196',
    storageBucket: 'cabrioletsochi-77196.appspot.com',
    iosClientId: '795491107509-cnmalapq3ga2sd2h87rnov359uu5uv84.apps.googleusercontent.com',
    iosBundleId: 'uz.futuretechnologiesinc.presidentftinc.cabrioletSochi',
  );
}
