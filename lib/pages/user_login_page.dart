import 'package:flutter/material.dart';
import 'otp_verification_page.dart';
import 'user_home_page.dart';
import '../services/auth_service.dart';

class UserLoginPage extends StatefulWidget {
  final AuthService? authService;
  const UserLoginPage({super.key, this.authService});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final _phoneController = TextEditingController();
  late final AuthService? auth;

  @override
  void initState() {
    super.initState();
    auth = widget.authService;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter phone number')));
      return;
    }
    final normalized = phone.startsWith('+') ? phone : '+91$phone';
    if (auth != null) {
      await auth!.sendOtp(normalized);
    }
  if (!mounted) return;
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => OtpVerificationPage(phoneNumber: normalized)));
  }

  @override
  Widget build(BuildContext context) {
  final greenAccent = Colors.green[400]!;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F12),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Card(
              color: const Color(0xFF0E1112),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('PingMyRide - User Login', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    // Google Sign-In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (auth != null) {
                            final uid = await auth!.signInWithGoogle();
                            if (!mounted) return;
                            if (uid != null) {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => UserHomePage(userName: 'Google User')));
                            }
                          }
                        },
                        icon: Image.asset('assets/google_logo.png', height: 20),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Continue with Google', style: TextStyle(fontSize: 16)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 18),

                    // Phone login
                        Align(alignment: Alignment.centerLeft, child: Text('Phone number', style: TextStyle(color: Colors.white.withAlpha((0.9 * 255).round())))),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(color: const Color(0xFF0B0F12), borderRadius: BorderRadius.circular(8)),
                          child: const Text('+91', style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Enter phone number',
                                  hintStyle: TextStyle(color: Colors.white.withAlpha((0.6 * 255).round())),
                              filled: true,
                              fillColor: const Color(0xFF141617),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _sendOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text('Send OTP', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
