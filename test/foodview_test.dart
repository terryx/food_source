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
import 'package:food_source/view/edit_food.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'mock/recipe_vault.dart';

Future<void> _addRecipe(WidgetTester tester, [name = 'Name Test']) async {
  await tester.tap(find.byKey(const Key('AddFood')));
  await tester.pumpAndSettle();

  final nameKey = find.byKey(const Key('Name'));
  final ingrKey = find.byKey(const Key('Ingredients'));
  final descKey = find.byKey(const Key('Description'));
  final saveKey = find.byKey(const Key('SaveFood'));

  await tester.enterText(nameKey, name);
  await tester.enterText(ingrKey, 'Ingredients Test');
  await tester.enterText(descKey, 'Description Test');

  await tester.tap(saveKey);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    RecipeVault.instance = MockRecipeVault();
  });

  testWidgets('Add Food view is visible', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(initialRoute: '/add_food'));
    const key = ValueKey('AddFoodForm');
    expect(find.byKey(key), findsOneWidget);
  });

  testWidgets('Can add new recipe', (WidgetTester tester) async {
    WidgetRef? ref;
    final myapp = ProviderScope(
      child: Consumer(
        builder: (c, r, _) {
          ref = r;

          return const MyApp(initialRoute: '/home');
        },
      ),
    );
    await tester.pumpWidget(myapp);

    /// Nothing is saved in memory initially, should be no recipe
    expect(ref?.read(recipesProvider).isEmpty, true);

    /// Verify no UI issues when there are many items in the list
    final list = Iterable<int>.generate(25).toList();
    for (var _ in list) {
      await _addRecipe(tester);
    }

    expect(find.byKey(const Key('RecipeList')), findsOneWidget);
    expect(ref?.read(recipesProvider).length, 25);
    expect(find.text('Name Test'), findsNWidgets(5));
  });

  testWidgets('Cannot add new recipe if no name present',
      (WidgetTester tester) async {
    final key = GlobalKey();
    final myapp = ProviderScope(
      child: MyApp(
        home: Container(key: key),
        initialRoute: '/add_food',
      ),
    );

    await tester.pumpWidget(myapp);

    final saveKey = find.byKey(const Key('SaveFood'));
    await tester.tap(saveKey);
    await tester.pump();

    final requiredText = find.text(Lz.of(key.currentContext!)!.requiredText);
    expect(requiredText, findsOneWidget);
  });

  testWidgets('Search food recipes', (WidgetTester tester) async {
    const myapp = ProviderScope(child: MyApp(initialRoute: '/home'));

    await tester.pumpWidget(myapp);
    await _addRecipe(tester, 'abc');
    await _addRecipe(tester, 'xyz');

    await tester.enterText(find.byType(TextField), 'xy');
    await tester.pump();
    expect(find.text('xyz'), findsOneWidget);
    expect(find.text('abc'), findsNothing);
  });

  testWidgets('Can edit recipe', (WidgetTester tester) async {
    const myapp = ProviderScope(child: MyApp(initialRoute: '/home'));

    await tester.pumpWidget(myapp);
    await _addRecipe(tester, 'Pineapple');
    await tester.tap(find.text('Pineapple'));
    await tester.pumpAndSettle();

    expect(find.byKey(EditFoodViewState.scaffoldKey), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Pineapple'), findsOneWidget);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Pineapple'), 'Pin abc');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Ingredients Test'), 'Ing abc');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Description Test'), 'Des abc');
    await tester.tap(find.byKey(EditFoodViewState.saveFoodKey));
    await tester.pumpAndSettle();

    expect(find.byKey(EditFoodViewState.scaffoldKey), findsNothing);
    expect(find.widgetWithText(ListTile, 'Pineapple'), findsNothing);
    expect(find.widgetWithText(ListTile, 'Pin abc'), findsOneWidget);
  });

  testWidgets('Cannot edit recipe without name', (WidgetTester tester) async {
    const myapp = ProviderScope(child: MyApp(initialRoute: '/home'));

    await tester.pumpWidget(myapp);
    await _addRecipe(tester, 'Pineapple');
    await tester.tap(find.text('Pineapple'));
    await tester.pumpAndSettle();

    expect(find.byKey(EditFoodViewState.scaffoldKey), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Pineapple'), findsOneWidget);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Pineapple'), '');
    await tester.tap(find.byKey(EditFoodViewState.saveFoodKey));
    await tester.pumpAndSettle();

    expect(find.byKey(EditFoodViewState.scaffoldKey), findsOneWidget);
  });

  testWidgets('Can remove recipe', (WidgetTester tester) async {
    const myapp = ProviderScope(child: MyApp(initialRoute: '/home'));

    await tester.pumpWidget(myapp);
    // await tester.pump();

    await _addRecipe(tester, 'Pineapple');
    await tester.tap(find.text('Pineapple'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(EditFoodViewState.delFoodKey));
    await tester.pumpAndSettle();

    expect(find.byKey(EditFoodViewState.scaffoldKey), findsNothing);
    expect(find.widgetWithText(ListTile, 'Pineapple'), findsNothing);
    expect(find.byType(ListTile), findsNothing);
  });
}
