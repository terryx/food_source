// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_source/controller/recipe.dart';
import 'package:food_source/localization.dart';

import 'package:food_source/main.dart';
import 'package:food_source/view/splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'mock/recipe_vault.dart';

/// Test with context using global key
/// More info refer to https://github.com/flutter/flutter/blob/e7b7ebc066c1b2a5aa5c19f8961307427e0142a6/packages/flutter/test/cupertino/localizations_test.dart#L38
void main() {
  setUp(() async {
    RecipeVault.instance = MockRecipeVault();
  });

  testWidgets('My app initial route on SplashView transition',
      (WidgetTester tester) async {
    const myapp = ProviderScope(child: MyApp(initialRoute: '/index'));

    // Verify splash screen title is visible when first onload.
    await tester.pumpWidget(myapp);
    final splashView = find.byType(SplashView);

    expect(splashView, findsOneWidget);
    await tester.pumpAndSettle(splashInDuration);

    expect(splashView, findsNothing);
  });

  testWidgets('Splash view localization', (WidgetTester tester) async {
    final key = GlobalKey();
    final myapp = ProviderScope(
      child: MyApp(
        home: Container(key: key, child: const SplashView()),
      ),
    );

    await tester.pumpWidget(myapp);
    final tagline = find.text(Lz.of(key.currentContext!)!.tagline);
    expect((tagline), findsOneWidget);

    await tester.pumpAndSettle(splashInDuration);
    expect((tagline), findsNothing);
  });
}
