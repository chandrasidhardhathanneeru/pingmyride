import 'package:flutter/material.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );

    return Scaffold(
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
              const SizedBox(height: 32),
              ElevatedButton(
                style: buttonStyle,
                onPressed: () => Navigator.pushNamed(context, '/user'),
                child: const Text('User Login', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: buttonStyle,
                onPressed: () => Navigator.pushNamed(context, '/driver'),
                child: const Text('Driver Login', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: buttonStyle.copyWith(backgroundColor: WidgetStateProperty.all(Colors.pinkAccent.shade200)),
                onPressed: () => Navigator.pushNamed(context, '/admin'),
                child: const Text('Admin Login', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
