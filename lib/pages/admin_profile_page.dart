import 'package:flutter/material.dart';

class AdminProfilePage extends StatelessWidget {
  final String adminName;
  final String adminEmail;
  const AdminProfilePage({super.key, this.adminName = 'Admin', this.adminEmail = 'admin@example.com'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(title: const Text('Profile'), backgroundColor: const Color(0xFF0E1112)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(width: 52, height: 52, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.person, color: Colors.black54)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(adminName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 6), Text(adminEmail, style: TextStyle(color: Colors.black54))])),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      ListTile(title: const Text('Account'), trailing: const Text('Details')),
                      const Divider(height: 1),
                      ListTile(title: const Text('Help & Support'), onTap: () {}, trailing: const Text('Contact')),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
