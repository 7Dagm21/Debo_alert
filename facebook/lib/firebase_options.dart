//
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyC677Rp5pj7gsyZWAdIJwm_n0lPMQqbdI8',
    appId: '1:604234550060:web:44a4822bb761a4c040ba89',
    messagingSenderId: '604234550060',
    projectId: 'facebook-4d032',
    authDomain: 'facebook-4d032.firebaseapp.com',
    storageBucket: 'facebook-4d032.firebasestorage.app',
    measurementId: 'G-YVNNB6M2MX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJ24cfnSiDJrpYqHxNsyAtKOcxKr90wYk',
    appId: '1:604234550060:android:c2c987a872ed3abd40ba89',
    messagingSenderId: '604234550060',
    projectId: 'facebook-4d032',
    storageBucket: 'facebook-4d032.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBuoaA48-_ZT1zpdeQyHnnSJjQDMwzKxqU',
    appId: '1:604234550060:ios:2e9d4affe8835ba140ba89',
    messagingSenderId: '604234550060',
    projectId: 'facebook-4d032',
    storageBucket: 'facebook-4d032.firebasestorage.app',
    iosClientId:
        '604234550060-3kkmreqm432lic500ics7nd379la46m2.apps.googleusercontent.com',
    iosBundleId: 'com.example.facebook',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBuoaA48-_ZT1zpdeQyHnnSJjQDMwzKxqU',
    appId: '1:604234550060:ios:2e9d4affe8835ba140ba89',
    messagingSenderId: '604234550060',
    projectId: 'facebook-4d032',
    storageBucket: 'facebook-4d032.firebasestorage.app',
    iosClientId:
        '604234550060-3kkmreqm432lic500ics7nd379la46m2.apps.googleusercontent.com',
    iosBundleId: 'com.example.facebook',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC677Rp5pj7gsyZWAdIJwm_n0lPMQqbdI8',
    appId: '1:604234550060:web:aa7833a6ba060bf640ba89',
    messagingSenderId: '604234550060',
    projectId: 'facebook-4d032',
    authDomain: 'facebook-4d032.firebaseapp.com',
    storageBucket: 'facebook-4d032.firebasestorage.app',
    measurementId: 'G-J9GX2HF2XW',
  );
}
