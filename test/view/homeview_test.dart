import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_source/controller/recipe.dart';

import 'package:food_source/main.dart';
import 'package:food_source/model/recipe.dart';
import 'package:food_source/view/home.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../fake/recipe_vault.dart';

/// The high level focus on multiple widgets, you ensure the screen is loaded without UI issues.
/// The low level focus on single widget, you ensure a widget can work in isolation.


void main() {
  const key = Key('RecipeList');
  setUp(() async {
    RecipeVault.instance = FakeRecipeVault();
  });

  /// High level
  /// Refer [FutureProvider] test at https://github.com/rrousselGit/riverpod/blob/master/packages/flutter_riverpod/test/future_provider_test.dart#L27
  testWidgets('Add Food button is visible by widget construction',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MyApp(home: HomeView())),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump();

    expect(find.byKey(key), findsOneWidget);
  });

  testWidgets('Add Food button is visible by route',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MyApp(initialRoute: '/home')),
    );
    await tester.pump();
    expect(find.byKey(key), findsOneWidget);

    await tester.tap(find.byKey(const Key('AddFood')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('AddFoodForm')));
  });

  testWidgets('no crash when read corrupted disk', (WidgetTester tester) async {
    RecipeVault.instance = FakeRecipeVault(contents: 'jibberish');
    await tester.pumpWidget(
      const ProviderScope(child: MyApp(initialRoute: '/home')),
    );

    await tester.pump();
    expect(find.byKey(key), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('show provider error', (WidgetTester tester) async {
    final error = Error();

    await tester.pumpWidget(
      ProviderScope(overrides: [
        recipesCache.overrideWithValue(AsyncValue.error(error)),
      ], child: const MyApp(initialRoute: '/home')),
    );

    await tester.pump();
    expect(find.byKey(key), findsNothing);
    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets('Can filter recipe', (WidgetTester tester) async {
    final list = Iterable<int>.generate(25).toList();
    final List<Recipe> recipes = [];
    for (var i in list) {
      recipes.add(Recipe.add(name: i.toString()));
    }
    RecipeVault.instance = FakeRecipeVault(initialRecipes: recipes);

    await tester.pumpWidget(
      const ProviderScope(child: MyApp(initialRoute: '/home')),
    );
    await tester.pump();
    expect(find.byKey(key), findsOneWidget);

    await tester.enterText(find.byKey(HomeViewMainContent.searchKey), '10');
    await tester.pump();
    expect(find.widgetWithText(ListTile, '2'), findsNothing);
    expect(find.widgetWithText(ListTile, '10'), findsOneWidget);

    await tester.enterText(find.byKey(HomeViewMainContent.searchKey), '');
    await tester.pump();
    expect(find.widgetWithText(ListTile, '2'), findsOneWidget);
    expect(find.widgetWithText(ListTile, '10'), findsNothing);
  });

  testWidgets('Search show lowercase and uppercase result',
      (WidgetTester tester) async {
    RecipeVault.instance = FakeRecipeVault(initialRecipes: [
      Recipe.add(name: 'Apple Pie'),
    ]);

    await tester.pumpWidget(
      const ProviderScope(child: MyApp(initialRoute: '/home')),
    );
    await tester.pump();

    await tester.enterText(find.byKey(HomeViewMainContent.searchKey), 'apple');
    await tester.pump();
    expect(find.widgetWithText(ListTile, 'Apple Pie'), findsOneWidget);
  });
}
