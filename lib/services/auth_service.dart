import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Result wrapper for authentication operations
class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? errorMessage;
  final bool isCancelled;

  const AuthResult._({
    required this.isSuccess,
    this.user,
    this.errorMessage,
    this.isCancelled = false,
  });

  factory AuthResult.success(User user) =>
      AuthResult._(isSuccess: true, user: user);

  factory AuthResult.cancelled() =>
      const AuthResult._(isSuccess: false, isCancelled: true);

  factory AuthResult.failure(String message) =>
      AuthResult._(isSuccess: false, errorMessage: message);
}

class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String webClientId =
      '33449994871-4pfst0aj5bi0p9fdm7qookmrn1o2i208.apps.googleusercontent.com';

  /// Check whether the device currently has active network connectivity
  Future<bool> hasInternetConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none) ||
        connectivityResult.isEmpty) {
      return false;
    }
    return true;
  }

  /// Sign in using Google OAuth and synchronize user data with Firestore & local storage
  Future<AuthResult> signInWithGoogle() async {
    final bool hasInternet = await hasInternetConnection();
    if (!hasInternet) {
      return AuthResult.failure(
        'No internet connection. Please check your network and try again.',
      );
    }

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: kIsWeb ? webClientId : null,
        serverClientId: webClientId,
        scopes: const ['email', 'profile'],
      );

      // Sign out from any previous Google session to ensure clean account picker
      try {
        await googleSignIn.signOut();
      } catch (_) {
        // Ignored if not previously signed in
      }

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User aborted the sign-in modal/flow
        return AuthResult.cancelled();
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final User? user = userCredential.user;
      if (user == null) {
        return AuthResult.failure('Unable to retrieve user credentials from Google.');
      }

      // 1. Sync User data with Firestore collection('users')
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName ?? googleUser.displayName ?? '',
          'email': user.email ?? googleUser.email,
          'photoUrl': user.photoURL ?? googleUser.photoUrl ?? '',
          'lastLoginAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (firestoreError) {
        debugPrint('Firestore User Sync Warning: $firestoreError');
      }

      // 2. Sync to local SharedPreferences for fast UI loading
      try {
        final prefs = await SharedPreferences.getInstance();
        if (user.displayName != null && user.displayName!.isNotEmpty) {
          await prefs.setString('profile_name', user.displayName!);
        }
        if (user.email != null && user.email!.isNotEmpty) {
          await prefs.setString('profile_email', user.email!);
        }
      } catch (prefError) {
        debugPrint('SharedPreferences Sync Warning: $prefError');
      }

      return AuthResult.success(user);
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Exception: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'account-exists-with-different-credential':
          return AuthResult.failure(
            'An account already exists with this email using another sign-in method.',
          );
        case 'invalid-credential':
          return AuthResult.failure('Invalid Google credentials. Please try again.');
        case 'operation-not-allowed':
          return AuthResult.failure(
            'Google Sign-In is not enabled in Firebase Console.',
          );
        case 'user-disabled':
          return AuthResult.failure('This user account has been disabled.');
        case 'network-request-failed':
          return AuthResult.failure(
            'Network request failed. Please verify your connection.',
          );
        default:
          return AuthResult.failure(e.message ?? 'Google Sign-In failed.');
      }
    } on PlatformException catch (e) {
      debugPrint('Platform Exception during Google Sign-In: ${e.code} - ${e.message}');
      if (e.code == 'sign_in_canceled') {
        return AuthResult.cancelled();
      }
      if (e.message != null &&
          (e.message!.contains('10') || e.message!.contains('12500'))) {
        return AuthResult.failure(
          'Google Sign-In configuration error (ApiException 10/12500). Please ensure SHA-1 fingerprint is registered in Firebase Console.',
        );
      }
      return AuthResult.failure(e.message ?? 'Platform error during Google Sign-In.');
    } catch (e) {
      debugPrint('Unexpected Google Sign-In error: $e');
      return AuthResult.failure('Google Sign-In Error: $e');
    }
  }

  /// Sign out completely from Firebase, Google Sign-In, and clear cached credentials
  Future<void> signOut() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: kIsWeb ? webClientId : null,
        serverClientId: webClientId,
      );
      await googleSignIn.signOut();
    } catch (e) {
      debugPrint('Google Sign-Out Warning: $e');
    }

    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      debugPrint('Firebase Sign-Out Warning: $e');
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('profile_name');
      await prefs.remove('profile_email');
      await prefs.remove('profile_image');
    } catch (e) {
      debugPrint('Preferences Clear Warning: $e');
    }
  }
}
