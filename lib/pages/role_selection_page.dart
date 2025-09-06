import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import 'unified_login_page.dart';

class RoleSelectionPage extends StatelessWidget {
  final AuthService? authService;
  
  const RoleSelectionPage({super.key, this.authService});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'PingMyRide',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose your role to continue',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              
              // Student Login
              ElevatedButton.icon(
                style: buttonStyle,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UnifiedLoginPage(
                      role: UserRole.student,
                      authService: authService ?? defaultAuthService,
                    ),
                  ),
                ),
                icon: const Icon(Icons.school, color: Colors.black),
                label: const Text('Student Login', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 16),
              
              // Driver Login
              ElevatedButton.icon(
                style: buttonStyle,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UnifiedLoginPage(
                      role: UserRole.driver,
                      authService: authService ?? defaultAuthService,
                    ),
                  ),
                ),
                icon: const Icon(Icons.directions_bus, color: Colors.black),
                label: const Text('Driver Login', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 16),
              
              // Admin Login
              ElevatedButton.icon(
                style: buttonStyle.copyWith(
                  backgroundColor: WidgetStateProperty.all(Colors.pinkAccent.shade200),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UnifiedLoginPage(
                      role: UserRole.admin,
                      authService: authService ?? defaultAuthService,
                    ),
                  ),
                ),
                icon: const Icon(Icons.admin_panel_settings, color: Colors.black),
                label: const Text('Admin Login', style: TextStyle(color: Colors.black)),
              ),
              
              const SizedBox(height: 24),
              _buildTestCredentialsInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestCredentialsInfo() {
    final testCreds = DatabaseService.getTestCredentials();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white70, size: 16),
              SizedBox(width: 8),
              Text(
                'Test Credentials Available',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...UserRole.values.map((role) {
            final creds = testCreds[role]!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      role.displayName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${creds['email']} / ${creds['password']}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 8),
          const Text(
            'Tap credentials in login screen to auto-fill',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 10,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
