import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sdcs_customer/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App builds and shows home screen in portrait', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ProviderScope(child: SDCSApp()));
    await tester.pumpAndSettle();

    expect(find.text('SDCS'), findsOneWidget);
  });
}
