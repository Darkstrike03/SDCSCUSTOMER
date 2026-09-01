import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sdcs_customer/app.dart';
import 'package:sdcs_customer/core/widgets/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App builds, shows splash, then login screen in portrait', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ProviderScope(child: SDCSApp()));
    await tester.pump();

    // Splash wordmark is shown initially (first language: English).
    expect(find.byKey(const ValueKey('wordmark-0')), findsOneWidget);

    // Advance past splash lifetime + fade; it becomes invisible.
    await tester.pump(kSplashTotalDuration);
    await tester.pump(kSplashFadeDuration);

    final splashOpacity = tester.widget<AnimatedOpacity>(
      find.byKey(const ValueKey('splash-opacity')),
    );
    expect(splashOpacity.opacity, 0);

    // Not authenticated on native -> router redirects to the login screen.
    expect(find.text('Welcome back'), findsOneWidget);
  });
}