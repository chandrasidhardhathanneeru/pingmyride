import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class DatabaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Test user credentials for easy login
  static const Map<UserRole, Map<String, String>> testCredentials = {
    UserRole.admin: {
      'email': 'admin@test.com',
      'password': 'admin123',
      'username': 'Test Admin'
    },
    UserRole.driver: {
      'email': 'driver@test.com',
      'password': 'driver123',
      'username': 'Test Driver'
    },
    UserRole.student: {
      'email': 'student@test.com',
      'password': 'student123',
      'username': 'Test Student'
    },
  };

  // Additional test accounts for more variety
  static const List<Map<String, dynamic>> additionalTestAccounts = [
    // Admin accounts
    {
      'email': 'admin1@pingmyride.com',
      'password': 'admin123',
      'username': 'John Admin',
      'role': UserRole.admin,
    },
    {
      'email': 'admin2@pingmyride.com',
      'password': 'admin456',
      'username': 'Sarah Manager',
      'role': UserRole.admin,
    },
    
    // Driver accounts
    {
      'email': 'driver1@pingmyride.com',
      'password': 'driver123',
      'username': 'Mike Driver',
      'role': UserRole.driver,
    },
    {
      'email': 'driver2@pingmyride.com',
      'password': 'driver456',
      'username': 'Lisa Transport',
      'role': UserRole.driver,
    },
    {
      'email': 'driver3@pingmyride.com',
      'password': 'driver789',
      'username': 'Carlos Rodriguez',
      'role': UserRole.driver,
    },
    
    // Student accounts
    {
      'email': 'student1@pingmyride.com',
      'password': 'student123',
      'username': 'Emma Student',
      'role': UserRole.student,
    },
    {
      'email': 'student2@pingmyride.com',
      'password': 'student456',
      'username': 'Alex Johnson',
      'role': UserRole.student,
    },
    {
      'email': 'student3@pingmyride.com',
      'password': 'student789',
      'username': 'Sophia Chen',
      'role': UserRole.student,
    },
    {
      'email': 'student4@pingmyride.com',
      'password': 'student101',
      'username': 'David Wilson',
      'role': UserRole.student,
    },
    {
      'email': 'student5@pingmyride.com',
      'password': 'student202',
      'username': 'Maya Patel',
      'role': UserRole.student,
    },
  ];

  // Initialize test accounts in Firebase Auth and Firestore
  static Future<void> initializeTestAccounts() async {
    try {
      print('🚀 Initializing test accounts...');
      
      for (final role in UserRole.values) {
        final credentials = testCredentials[role]!;
        final email = credentials['email']!;
        final password = credentials['password']!;
        final username = credentials['username']!;

        try {
          // Check if user already exists in Firestore
          final existingUser = await _firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

          if (existingUser.docs.isEmpty) {
            // Create Firebase Auth account
            UserCredential userCredential;
            try {
              userCredential = await _auth.createUserWithEmailAndPassword(
                email: email,
                password: password,
              );
            } catch (e) {
              // If user already exists in Auth, try to sign in to get the UID
              userCredential = await _auth.signInWithEmailAndPassword(
                email: email,
                password: password,
              );
            }

            // Create user document in Firestore
            final appUser = AppUser(
              uid: userCredential.user!.uid,
              email: email,
              username: username,
              role: role,
              createdAt: DateTime.now(),
            );

            await _firestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .set(appUser.toMap());

            print('✅ Created test account: $email (${role.displayName})');
          } else {
            print('✅ Test account already exists: $email (${role.displayName})');
          }
        } catch (e) {
          print('❌ Error creating test account $email: $e');
        }
      }

      // Sign out after creating accounts
      await _auth.signOut();
      print('🔧 Test accounts initialization completed');
      print('');
      print('📋 TEST CREDENTIALS:');
      for (final role in UserRole.values) {
        final creds = testCredentials[role]!;
        print('${role.displayName}: ${creds['email']} / ${creds['password']}');
      }
      print('');
      
    } catch (e) {
      print('❌ Error initializing test accounts: $e');
    }
  }

  // Create additional test accounts for more variety
  static Future<void> createAdditionalTestAccounts() async {
    try {
      print('🚀 Creating additional test accounts...');
      
      for (final accountData in additionalTestAccounts) {
        final email = accountData['email'] as String;
        final password = accountData['password'] as String;
        final username = accountData['username'] as String;
        final role = accountData['role'] as UserRole;

        try {
          // Check if user already exists in Firestore
          final existingUser = await _firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

          if (existingUser.docs.isEmpty) {
            // Create Firebase Auth account
            UserCredential userCredential;
            try {
              userCredential = await _auth.createUserWithEmailAndPassword(
                email: email,
                password: password,
              );
            } catch (e) {
              // If user already exists in Auth, try to sign in to get the UID
              userCredential = await _auth.signInWithEmailAndPassword(
                email: email,
                password: password,
              );
            }

            // Create user document in Firestore
            final appUser = AppUser(
              uid: userCredential.user!.uid,
              email: email,
              username: username,
              role: role,
              createdAt: DateTime.now(),
            );

            await _firestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .set(appUser.toMap());

            print('✅ Created account: $email (${role.displayName})');
          } else {
            print('✅ Account already exists: $email (${role.displayName})');
          }
        } catch (e) {
          print('❌ Error creating account $email: $e');
        }
      }

      // Sign out after creating accounts
      await _auth.signOut();
      print('🔧 Additional accounts creation completed');
      
    } catch (e) {
      print('❌ Error creating additional accounts: $e');
    }
  }

  // Get user by email and role (for login validation)
  static Future<AppUser?> getUserByEmailAndRole(String email, UserRole role) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('role', isEqualTo: role.name)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return AppUser.fromMap(query.docs.first.data());
      }
    } catch (e) {
      print('Error getting user by email and role: $e');
    }
    return null;
  }

  // Update user profile
  static Future<bool> updateUserProfile(String uid, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('users').doc(uid).update(updates);
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  // Get all users by role (for admin dashboard)
  static Future<List<AppUser>> getUsersByRole(UserRole role) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('role', isEqualTo: role.name)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs.map((doc) => AppUser.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error getting users by role: $e');
      return [];
    }
  }

  // Deactivate user account
  static Future<bool> deactivateUser(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({'isActive': false});
      return true;
    } catch (e) {
      print('Error deactivating user: $e');
      return false;
    }
  }

  // Get test credentials for display
  static Map<UserRole, Map<String, String>> getTestCredentials() {
    return testCredentials;
  }

  // Create a single new user account
  static Future<bool> createNewUserAccount({
    required String email,
    required String password,
    required String username,
    required UserRole role,
  }) async {
    try {
      // Check if user already exists
      final existingUser = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (existingUser.docs.isNotEmpty) {
        print('❌ User with email $email already exists');
        return false;
      }

      // Create Firebase Auth account
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      final appUser = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        username: username,
        role: role,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(appUser.toMap());

      print('✅ Successfully created account: $email (${role.displayName})');
      return true;
    } catch (e) {
      print('❌ Error creating account: $e');
      return false;
    }
  }

  // Get all test accounts for display
  static List<Map<String, dynamic>> getAllTestAccounts() {
    List<Map<String, dynamic>> allAccounts = [];
    
    // Add main test credentials
    testCredentials.forEach((role, creds) {
      allAccounts.add({
        'email': creds['email'],
        'password': creds['password'],
        'username': creds['username'],
        'role': role,
      });
    });
    
    // Add additional test accounts
    allAccounts.addAll(additionalTestAccounts);
    
    return allAccounts;
  }
}
