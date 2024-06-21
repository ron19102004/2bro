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
    apiKey: 'AIzaSyBxc62UvonganpFFMpre5ptAE9ok0lEFJE',
    appId: '1:457414534507:web:410b2456906178d095582e',
    messagingSenderId: '457414534507',
    projectId: 'bro-46353',
    authDomain: 'bro-46353.firebaseapp.com',
    storageBucket: 'bro-46353.appspot.com',
    measurementId: 'G-6BW3M1W78M',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBEvmUU1T2f14CGY4OKW2DqKS3E0yDVf94',
    appId: '1:457414534507:android:38895ac54e5e151a95582e',
    messagingSenderId: '457414534507',
    projectId: 'bro-46353',
    storageBucket: 'bro-46353.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCjLs1huj9x6WAiDGu4D05jW_kj_jcRwsY',
    appId: '1:457414534507:ios:80bde816ef08789295582e',
    messagingSenderId: '457414534507',
    projectId: 'bro-46353',
    storageBucket: 'bro-46353.appspot.com',
    iosBundleId: 'com.example.appChat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCjLs1huj9x6WAiDGu4D05jW_kj_jcRwsY',
    appId: '1:457414534507:ios:80bde816ef08789295582e',
    messagingSenderId: '457414534507',
    projectId: 'bro-46353',
    storageBucket: 'bro-46353.appspot.com',
    iosBundleId: 'com.example.appChat',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBxc62UvonganpFFMpre5ptAE9ok0lEFJE',
    appId: '1:457414534507:web:b11329563eecaa8e95582e',
    messagingSenderId: '457414534507',
    projectId: 'bro-46353',
    authDomain: 'bro-46353.firebaseapp.com',
    storageBucket: 'bro-46353.appspot.com',
    measurementId: 'G-RSD8FCWL8M',
  );
}
