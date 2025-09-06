import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final bool isDriver;
  final AuthService? authService;
  
  const ProfilePage({
    super.key, 
    required this.userName, 
    this.isDriver = false,
    this.authService,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _online = true;
  bool _notificationsOn = true;
  String _paymentMethod = 'UPI';

  @override
  Widget build(BuildContext context) {
    if (widget.isDriver) {
      // Driver layout (existing)
      return Scaffold(
        backgroundColor: const Color(0xFFF6F7F9),
        body: SafeArea(
          child: Column(
            children: [
              // Top curved header
              Container(
                height: 64,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF0E1112),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Driver Profile', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Account', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Driver card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.person, color: Colors.black54),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.userName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text('DL: TN-123456', style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Options card (online status + help & support)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      // Online status row with colored action button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Online Status', style: TextStyle(fontSize: 16, color: Colors.black)),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _online ? Colors.green : Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () => setState(() => _online = !_online),
                              child: Text(_online ? 'Go Offline' : 'Go Online'),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Help & Support', style: TextStyle(color: Colors.black)),
                        trailing: TextButton(
                          onPressed: () {
                            // Placeholder: simulate call action
                          },
                          child: const Text('Call', style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Logout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    child: const Text('Logout', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // User / Student profile layout
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      body: SafeArea(
        child: Column(
          children: [
            // Top curved header
            Container(
              height: 64,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF0E1112),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Profile', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Account', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Student card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.person, color: Colors.black54),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Student Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('${widget.userName}@college.edu', style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Options card (notifications, payment, help)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Notifications', style: TextStyle(color: Colors.black)),
                      trailing: Text(_notificationsOn ? 'On' : 'Off', style: const TextStyle(color: Colors.black54)),
                      onTap: () => setState(() => _notificationsOn = !_notificationsOn),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Payment Method', style: TextStyle(color: Colors.black)),
                      trailing: Text(_paymentMethod, style: const TextStyle(color: Colors.black54)),
                      onTap: () async {
                        final res = await showMenu<String>(
                          context: context,
                          position: const RelativeRect.fromLTRB(100, 200, 100, 100),
                          items: [
                            const PopupMenuItem(value: 'UPI', child: Text('UPI')),
                            const PopupMenuItem(value: 'Card', child: Text('Card')),
                          ],
                        );
                        if (res != null) setState(() => _paymentMethod = res);
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: const Text('Help & Support', style: TextStyle(color: Colors.black)),
                      trailing: TextButton(
                        onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(title: const Text('FAQ'), content: const Text('Frequently asked questions...'), actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))])),
                        child: const Text('FAQ', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () async {
                    final authSvc = widget.authService ?? defaultAuthService;
                    await authSvc.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                    }
                  },
                  child: const Text('Logout', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
