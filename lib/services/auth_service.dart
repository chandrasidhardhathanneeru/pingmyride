import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;

abstract class AuthService {
  Future<String?> signInWithGoogle();
  /// Sends OTP and returns the [verificationId] from Firebase (or null on failure).
  Future<String?> sendOtp(String phoneNumber);
  /// Verifies the [smsCode] against the [verificationId].
  Future<bool> verifyOtp(String verificationId, String smsCode);
}

class FirebaseAuthService implements AuthService {
  fb.FirebaseAuth? _auth;

  FirebaseAuthService() {
    try {
      _auth = fb.FirebaseAuth.instance;
    } catch (e) {
      print('Firebase Auth not available: $e');
      _auth = null;
    }
  }

  @override
  Future<String?> signInWithGoogle() async {
    if (_auth == null) return null;
  // Placeholder implementation: Google sign-in requires the google_sign_in
  // package flow to obtain tokens, then authenticate with Firebase.
  // Return null for now; replace with a proper implementation matching
  // your selected google_sign_in version.
  return null;
  }

  @override
  Future<String?> sendOtp(String phoneNumber) async {
    if (_auth == null) return null;
    final completer = Completer<String?>();
    try {
      await _auth!.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (fb.PhoneAuthCredential credential) async {
          // Auto-retrieval or instant verification
          final userCred = await _auth!.signInWithCredential(credential);
          if (userCred.user != null) {
            completer.complete('auto');
          }
        },
        verificationFailed: (e) {
          completer.complete(null);
        },
        codeSent: (verificationId, resendToken) {
          completer.complete(verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          // timeout
        },
      );
    } catch (e) {
      completer.complete(null);
    }
    return completer.future;
  }

  @override
  Future<bool> verifyOtp(String verificationId, String smsCode) async {
    if (_auth == null) return false;
    try {
      final credential = fb.PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      final userCred = await _auth!.signInWithCredential(credential);
      return userCred.user != null;
    } catch (e) {
      return false;
    }
  }
}

// Default runtime service. Tests can inject a fake via the app constructor.
final AuthService defaultAuthService = FirebaseAuthService();
