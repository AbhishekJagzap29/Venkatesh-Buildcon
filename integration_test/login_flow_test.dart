import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:venkatesh_buildcon_app/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Clear state and reset Get navigation between tests
  setUp(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.reset();
  });

  tearDown(() async {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
  });

  // ─────────────────────────────────────────────────────────────────
  // Shared helper – brings the app to the Login screen
  // Flow: Splash (3 s timer) → Intro screen → tap Skip → Login
  // ─────────────────────────────────────────────────────────────────
  Future<void> goToLoginScreen(WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Advance past the SplashScreen's 3-second Future.delayed
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // If the Intro screen appeared, tap "SKIP" to jump to Login
    final skipFinder = find.text('SKIP');
    final skipFallback = find.widgetWithText(TextButton, 'SKIP');

    if (skipFinder.evaluate().isNotEmpty) {
      await tester.tap(skipFinder);
      await tester.pumpAndSettle();
    } else if (skipFallback.evaluate().isNotEmpty) {
      await tester.tap(skipFallback);
      await tester.pumpAndSettle();
    }

    // Wait until the login email field is visible
    for (int i = 0; i < 20; i++) {
      if (find.byKey(const Key('login_email_field')).evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 300));
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // TEST 1 ✅  Enter username + password → tap Login → success
  // ─────────────────────────────────────────────────────────────────
  testWidgets(
    'Login with valid credentials navigates to home screen',
    (tester) async {
      await goToLoginScreen(tester);

      // ── Step 1: Enter username ──
      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'hqi.m',
      );
      await tester.pump();

      // ── Step 2: Enter password ──
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        '123',
      );
      await tester.pump();

      // ── Step 3: Tap Login button ──
      await tester.tap(find.byKey(const Key('login_submit_btn')));
      await tester.pump();

      // ── Step 4: Wait for API response + navigation (up to 20 s) ──
      for (int i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        // Break as soon as login screen widgets disappear (navigated away)
        if (find.byKey(const Key('login_email_field')).evaluate().isEmpty) break;
      }

      // ── Step 5: Assert we left the login screen ──
      expect(
        find.byKey(const Key('login_email_field')),
        findsNothing,
        reason: 'App should navigate to home after successful login',
      );
      expect(
        find.byKey(const Key('login_submit_btn')),
        findsNothing,
        reason: 'Login button should not be on the home screen',
      );

      // Wait for success snackbar animation (500ms delay + 2s display) to finish cleanly
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );

  // ─────────────────────────────────────────────────────────────────
  // TEST 2 ✅  Empty username + password → shows Required Field error
  // ─────────────────────────────────────────────────────────────────
  testWidgets(
    'Empty username and password shows Required Field error',
    (tester) async {
      await goToLoginScreen(tester);

      // Tap login without filling anything
      await tester.tap(find.byKey(const Key('login_submit_btn')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(
        find.textContaining('Required Field', findRichText: true),
        findsAny,
        reason: 'Should show Required Field snackbar when both fields are empty',
      );

      // Wait for snackbar duration to finish and dismiss
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

  // ─────────────────────────────────────────────────────────────────
  // TEST 3 ✅  Wrong credentials → shows Login Failed error
  // ─────────────────────────────────────────────────────────────────
  testWidgets(
    'Wrong credentials show Login Failed error',
    (tester) async {
      await goToLoginScreen(tester);

      await tester.enterText(
        find.byKey(const Key('login_email_field')),
        'wronguser',
      );
      await tester.pump();

      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        'wrongpass',
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('login_submit_btn')));
      await tester.pump();

      // Wait for API response (up to 20 s)
      for (int i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 500));
        if (find
            .textContaining('Login Failed', findRichText: true)
            .evaluate()
            .isNotEmpty) break;
      }

      expect(
        find.textContaining('Login Failed', findRichText: true),
        findsAny,
        reason: 'Should show Login Failed snackbar for wrong credentials',
      );

      // Wait for snackbar duration to finish and dismiss
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
