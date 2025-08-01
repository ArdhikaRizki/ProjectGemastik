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
    apiKey: 'AIzaSyD4Sv9H9Uj0Pg2UN72Q6Gi0nGNdrdsoV3g',
    appId: '1:303307590213:web:798f10b29877b0babef12c',
    messagingSenderId: '303307590213',
    projectId: 'projekgemastik',
    authDomain: 'projekgemastik.firebaseapp.com',
    storageBucket: 'projekgemastik.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAsmDbFCSOJzpT8TIRFu-8Ot9IjimCS3qs',
    appId: '1:303307590213:android:aadaca237ad97260bef12c',
    messagingSenderId: '303307590213',
    projectId: 'projekgemastik',
    storageBucket: 'projekgemastik.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAwlMDpBhVjittUoYaktGkWP7RyP6zs1p8',
    appId: '1:303307590213:ios:32c6a346cab43194bef12c',
    messagingSenderId: '303307590213',
    projectId: 'projekgemastik',
    storageBucket: 'projekgemastik.firebasestorage.app',
    iosBundleId: 'com.example.projectGemastik',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAwlMDpBhVjittUoYaktGkWP7RyP6zs1p8',
    appId: '1:303307590213:ios:32c6a346cab43194bef12c',
    messagingSenderId: '303307590213',
    projectId: 'projekgemastik',
    storageBucket: 'projekgemastik.firebasestorage.app',
    iosBundleId: 'com.example.projectGemastik',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD4Sv9H9Uj0Pg2UN72Q6Gi0nGNdrdsoV3g',
    appId: '1:303307590213:web:a3175536069c1593bef12c',
    messagingSenderId: '303307590213',
    projectId: 'projekgemastik',
    authDomain: 'projekgemastik.firebaseapp.com',
    storageBucket: 'projekgemastik.firebasestorage.app',
  );
}
