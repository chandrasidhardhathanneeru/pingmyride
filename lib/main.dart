import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth_service.dart';
import 'pages/role_selection_page.dart';
import 'pages/user_login_page.dart';
import 'pages/driver_login_page.dart';
import 'pages/admin_login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Firebase initialization failed, continue without Firebase
    print('Firebase initialization failed: $e');
  }
  runApp(const PingMyRideApp());
}

class PingMyRideApp extends StatelessWidget {
  final AuthService? authService;
  const PingMyRideApp({super.key, this.authService});

  @override
  Widget build(BuildContext context) {
    final greenAccent = Colors.green[400]!;

  final auth = authService ?? defaultAuthService;

  return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PingMyRide',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0F12),
        colorScheme: ThemeData.dark().colorScheme.copyWith(
          primary: Colors.white,
          secondary: greenAccent,
        ),
        // Ensure default text is black (per request) across the app.
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[600],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF111417),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
  '/': (context) => const RoleSelectionPage(),
  '/user': (context) => UserLoginPage(authService: auth),
        '/driver': (context) => const DriverLoginPage(),
        '/admin': (context) => const AdminLoginPage(),
      },
    );
  }
}
