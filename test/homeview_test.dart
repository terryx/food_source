// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_source/controller/recipe.dart';

import 'package:food_source/main.dart';
import 'package:food_source/model/recipe.dart';
import 'package:food_source/view/home.dart';
import 'package:food_source/widget/recipe_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'mock/recipe_vault.dart';


/// 3 Level of widget/component test
/// The high level focus on screen, you ensure the screen is loaded without UI issues.
/// The med level focus on widget collection, you ensure multiple widget loaded without UI issues.
/// The low level focus on single widget, you ensure a widget can work in isolation.
void main() {
  const key = Key('RecipeList');
  setUp(() async {
    RecipeVault.instance = MockRecipeVault();
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

    expect(find.byKey(const Key('RecipeList')), findsOneWidget);
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

  /// Low level
  /// Example in https://github.com/flutter/flutter/blob/master/packages/flutter/test/widgets/list_view_test.dart#L115
  testWidgets('Home view recipes list', (WidgetTester tester) async {
    late StateSetter stateSetter;

    List<Recipe> recipes = <Recipe>[
      Recipe.add(name: 'Steak', ingredients: 'beef ribeye, salt, pepper'),
      Recipe.add(name: 'Sear Salmon', description: 'Pan sear salmon'),
    ];

    const newRecipeName = 'Tomato Pasta';
    onTap(Recipe r) {
      expect(r.name, newRecipeName);
    }

    await tester.pumpWidget(
      MyApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              stateSetter = setState;

              return RecipeList(recipes: recipes, onTap: onTap);
            },
          ),
        ),
      ),
    );

    expect(find.byKey(key), findsOneWidget);
    expect(find.text('Sear Salmon'), findsOneWidget);

    stateSetter(() => recipes.add(Recipe.add(name: newRecipeName)));
    await tester.pump();

    final item = find.text(newRecipeName);
    expect(item, findsOneWidget);

    await tester.tap(item);
  });
}
