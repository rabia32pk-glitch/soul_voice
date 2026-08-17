import 'package:firebase_core/firebase_core.dart';
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyB-HiwXfB373oT_mFivsZ9-bLzJ9LwVvY8",
    appId: "1:1088484110321:web:b1d8e137887e2aff0d139d",
    messagingSenderId: "1088484110321",
    projectId: "chatapp-ef1f8",
    authDomain: "chatapp-ef1f8.firebaseapp.com",
    storageBucket: "chatapp-ef1f8.appspot.com",
    measurementId: "G-G6L1F9ZCE8",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyB-HiwXfB373oT_mFivsZ9-bLzJ9LwVvY8",
    appId: "1:1088484110321:android:3e020fe44a8069d2d139d",
    messagingSenderId: "1088484110321",
    projectId: "chatapp-ef1f8",
    storageBucket: "chatapp-ef1f8.appspot.com",
  );
}
