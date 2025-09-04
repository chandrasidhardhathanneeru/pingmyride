import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pingmyride/main.dart';
import 'package:pingmyride/services/auth_service.dart';

class FakeAuthService implements AuthService {
  @override
  Future<String?> signInWithGoogle() async {
    return 'fake-uid';
  }

  @override
  @override
  Future<String?> sendOtp(String phoneNumber) async {
    return 'fake-verification-id';
  }

  @override
  Future<bool> verifyOtp(String verificationId, String smsCode) async {
    return true;
  }
}

void main() {
  testWidgets('navigation from role selection to user login and OTP', (WidgetTester tester) async {
    await tester.pumpWidget(const PingMyRideApp());
    // RoleSelectionPage shows PingMyRide
    expect(find.text('PingMyRide'), findsOneWidget);

    // Tap User Login
    await tester.tap(find.text('User Login'));
    await tester.pumpAndSettle();

    // On UserLoginPage
    expect(find.text('PingMyRide - User Login'), findsOneWidget);

    // Enter phone and press Send OTP
    await tester.enterText(find.byType(TextField).first, '9876543210');
    await tester.tap(find.text('Send OTP'));
    await tester.pumpAndSettle();

    // OTP page should appear
    expect(find.textContaining('OTP sent to'), findsOneWidget);
  });
}
