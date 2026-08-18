import 'package:firebase_core/firebase_core.dart';
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBOu5iYFJ0lCxI8mHMdMIlvumGaALozYas',
    appId: '1:33449994871:web:b4e5344e480d3aba483472',
    messagingSenderId: '33449994871',
    projectId: 'soul-voice-612eb',
    authDomain: 'soul-voice-612eb.firebaseapp.com',
    storageBucket: 'soul-voice-612eb.firebasestorage.app',
    measurementId: 'G-Q9WLGD0XHN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAcDeWgbrcHQKBIh8XEFCJx-icuy9RpJJY',
    appId: '1:33449994871:android:8b68a72f3ad8ab63483472',
    messagingSenderId: '33449994871',
    projectId: 'soul-voice-612eb',
    storageBucket: 'soul-voice-612eb.firebasestorage.app',
  );
}
