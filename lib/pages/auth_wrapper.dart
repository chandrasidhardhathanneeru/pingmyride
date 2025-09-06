import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'role_selection_page.dart';
import 'admin_home_page.dart';
import 'driver_home_page.dart';
import 'user_home_page.dart';

class AuthWrapper extends StatelessWidget {
  final AuthService authService;

  const AuthWrapper({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        print('AuthWrapper - Connection state: ${snapshot.connectionState}');
        print('AuthWrapper - Has data: ${snapshot.hasData}');
        print('AuthWrapper - Data: ${snapshot.data}');
        print('AuthWrapper - Error: ${snapshot.error}');
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading...'),
                ],
              ),
            ),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          print('AuthWrapper - No user, showing role selection');
          return RoleSelectionPage(authService: authService);
        }

        print('AuthWrapper - User found: ${user.username} (${user.role})');
        // Navigate based on user role
        switch (user.role) {
          case UserRole.admin:
            return AdminHomePage(adminName: user.username, authService: authService);
          case UserRole.driver:
            return DriverHomePage(driverName: user.username, authService: authService);
          case UserRole.student:
            return UserHomePage(userName: user.username, authService: authService);
        }
      },
    );
  }
}
