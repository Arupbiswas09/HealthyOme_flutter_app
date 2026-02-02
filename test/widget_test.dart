// Basic Flutter widget test for Healthy-O-Me app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthy_o_me/app/app.dart';

void main() {
  testWidgets('App loads and shows home', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: HealthyOmeApp(),
      ),
    );

    // Allow router to settle
    await tester.pumpAndSettle();

    // App should show something (home or shell). Just verify no crash.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
