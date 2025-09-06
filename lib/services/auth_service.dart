import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

abstract class AuthService {
  Future<String?> signInWithGoogle();
  Future<String?> sendOtp(String phoneNumber);
  Future<bool> verifyOtp(String verificationId, String smsCode);
  Future<AppUser?> signInWithEmailAndPassword(String email, String password);
  Future<AppUser?> registerUser(String email, String password, String username, UserRole role);
  Future<void> signOut();
  Future<AppUser?> getCurrentUser();
  Stream<AppUser?> get authStateChanges;
}

class FirebaseAuthService implements AuthService {
  fb.FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;

  FirebaseAuthService() {
    try {
      _auth = fb.FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
    } catch (e) {
      print('Firebase Auth not available: $e');
      _auth = null;
      _firestore = null;
    }
  }

  @override
  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    if (_auth == null || _firestore == null) return null;

    try {
      final userCredential = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final appUser = await _getUserFromFirestore(userCredential.user!.uid);
        return appUser;
      }
    } catch (e) {
      print('Sign in error: $e');
    }
    return null;
  }

  // New method: Sign in with role validation
  Future<AppUser?> signInWithEmailPasswordAndRole(String email, String password, UserRole expectedRole) async {
    if (_auth == null || _firestore == null) return null;

    try {
      final userCredential = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final appUser = await _getUserFromFirestore(userCredential.user!.uid);
        
        // Check if the user's role matches the expected role
        if (appUser != null && appUser.role != expectedRole) {
          // Sign out the user since role doesn't match
          await _auth!.signOut();
          throw Exception('Role mismatch: This account is registered as ${appUser.role.displayName}, but you tried to login as ${expectedRole.displayName}');
        }
        
        return appUser;
      }
    } catch (e) {
      print('Sign in with role validation error: $e');
      rethrow;
    }
    return null;
  }

  @override
  Future<AppUser?> registerUser(String email, String password, String username, UserRole role) async {
    if (_auth == null || _firestore == null) return null;

    try {
      final userCredential = await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final appUser = AppUser(
          uid: userCredential.user!.uid,
          email: email,
          username: username,
          role: role,
          createdAt: DateTime.now(),
        );

        await _firestore!.collection('users').doc(userCredential.user!.uid).set(appUser.toMap());
        return appUser;
      }
    } catch (e) {
      print('Registration error: $e');
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    if (_auth != null) {
      await _auth!.signOut();
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    if (_auth == null) return null;

    final user = _auth!.currentUser;
    if (user != null) {
      return await _getUserFromFirestore(user.uid);
    }
    return null;
  }

  @override
  Stream<AppUser?> get authStateChanges {
    if (_auth == null) return Stream.value(null);

    return _auth!.authStateChanges().asyncMap((user) async {
      if (user != null) {
        return await _getUserFromFirestore(user.uid);
      }
      return null;
    });
  }

  Future<AppUser?> _getUserFromFirestore(String uid) async {
    if (_firestore == null) {
      print('Firestore not available');
      return null;
    }

    try {
      print('Fetching user data from Firestore for UID: $uid');
      final doc = await _firestore!.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final userData = doc.data()!;
        print('User data found: ${userData}');
        return AppUser.fromMap(userData);
      } else {
        print('User document does not exist in Firestore for UID: $uid');
        // If user doesn't exist in Firestore, sign them out to prevent loop
        await signOut();
        return null;
      }
    } catch (e) {
      print('Error getting user from Firestore: $e');
      // If there's a database error, sign out to prevent authentication loop
      await signOut();
      return null;
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
      final credential = fb.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCred = await _auth!.signInWithCredential(credential);
      return userCred.user != null;
    } catch (e) {
      return false;
    }
  }
}

// Default runtime service. Tests can inject a fake via the app constructor.
final AuthService defaultAuthService = FirebaseAuthService();
