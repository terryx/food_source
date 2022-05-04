// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:food_source/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('Add Food view is visible', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(initialRoute: '/add_food'));
    const key = ValueKey('AddFoodForm');
    expect(find.byKey(key), findsOneWidget);
  });

  testWidgets('Can add new recipe', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp(initialRoute: '/add_food')));

    final nameKey = find.byKey(const Key('Name'));
    final ingrKey = find.byKey(const Key('Ingredients'));
    final descKey = find.byKey(const Key('Description'));
    final saveKey = find.byKey( const Key('SaveFood'));

    await tester.enterText(nameKey, 'Name Test');
    await tester.enterText(ingrKey, 'Ingredients Test');
    await tester.enterText(descKey, 'Description Test');
    await tester.tap(saveKey);
  });
}
