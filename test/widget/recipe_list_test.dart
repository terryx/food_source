// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_source/main.dart';
import 'package:food_source/model/recipe.dart';
import 'package:food_source/widget/recipe_list.dart';

void main() {
  const key = Key('RecipeList');

  /// Example in https://github.com/flutter/flutter/blob/master/packages/flutter/test/widgets/list_view_test.dart#L115
  testWidgets('Homeview recipes list', (WidgetTester tester) async {
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
