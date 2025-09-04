import 'package:flutter/material.dart';
import 'user_home_page.dart';
import '../services/auth_service.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final AuthService? authService;
  const OtpVerificationPage({super.key, required this.phoneNumber, this.authService});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _controllers.map((c) => c.text).join();
    bool ok = false;
    if (widget.authService != null) {
      // This sample doesn't keep verificationId; in a real flow you'd pass it.
      ok = await widget.authService!.verifyOtp('verificationId', code);
    }
    // Avoid using BuildContext across async gaps.
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => UserHomePage(userName: widget.phoneNumber)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid OTP or authentication not available')));
    }
  }

  void _resend() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP resent')));
  }

  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 42,
      child: TextField(
        controller: _controllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        maxLength: 1,
        decoration: const InputDecoration(counterText: '', filled: true, fillColor: Color(0xFF141617), border: OutlineInputBorder()),
        onChanged: (v) {
          if (v.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F12),
      body: SafeArea(
        child: Center(
          child: Card(
            color: const Color(0xFF0E1112),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('OTP sent to ${widget.phoneNumber}', style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (i) => _buildOtpField(i)),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _verify,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green[400], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Verify OTP'),
                      ),
                    ),
                  ),
                  TextButton(onPressed: _resend, child: const Text('Resend OTP', style: TextStyle(color: Colors.white70))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
