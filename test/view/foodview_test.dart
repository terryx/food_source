import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_source/controller/recipe.dart';
import 'package:food_source/localization.dart';

import 'package:food_source/main.dart';
import 'package:food_source/model/recipe.dart';
import 'package:food_source/view/edit_food.dart';
import 'package:food_source/view/home.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:faker/faker.dart';

import '../fake/recipe_vault.dart';

Future<void> _addRecipe(WidgetTester tester, [name = 'Name Test']) async {
  final faker = Faker(provider: FakerDataProviderFa());
  final fakeSentences100 = faker.lorem.sentences(100).join('\n');
  await tester.tap(find.byKey(const Key('AddFood')));
  await tester.pumpAndSettle();

  final nameKey = find.byKey(const Key('Name'));
  final ingrKey = find.byKey(const Key('Ingredients'));
  final descKey = find.byKey(const Key('Description'));
  final saveKey = find.byKey(const Key('SaveFood'));

  await tester.enterText(nameKey, name);
  await tester.enterText(ingrKey, 'Ingredients Test');
  await tester.enterText(descKey, fakeSentences100);

  await tester.tap(saveKey);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    RecipeVault.instance = FakeRecipeVault();
  });

  testWidgets('Add Food view is visible', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(initialRoute: '/add_food'));
    const key = ValueKey('AddFoodForm');
    expect(find.byKey(key), findsOneWidget);
  });

  testWidgets('Can add new recipe', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(640, 320));
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
    RecipeVault.instance = FakeRecipeVault(
      initialRecipes: [Recipe.add(name: 'Pineapple')],
    );
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
    await tester.pump();
    await tester.tap(find.text('Pineapple'));
    await tester.pumpAndSettle();

    expect(find.byKey(EditFoodViewState.scaffoldKey), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Pineapple'), findsOneWidget);

    await tester.enterText(find.byKey(EditFoodViewState.textNameKey), 'Pin a');
    await tester.enterText(find.byKey(EditFoodViewState.textIngrKey), 'Ing a');
    await tester.enterText(find.byKey(EditFoodViewState.textDescKey), 'Des a');
    await tester.tap(find.byKey(EditFoodViewState.saveFoodKey));
    await tester.pumpAndSettle();

    expect(find.byKey(EditFoodViewState.scaffoldKey), findsNothing);
    expect(find.widgetWithText(ListTile, 'Pineapple'), findsNothing);

    // Verify all data has updated successfully.
    expect(ref?.read(recipesProvider).first.name, 'Pin a');
    expect(ref?.read(recipesProvider).first.ingredients, 'Ing a');
    expect(ref?.read(recipesProvider).first.description, 'Des a');
  });

  testWidgets('Can edit in long texts', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(640, 320));
    final faker = Faker(provider: FakerDataProviderFa());
    final fakeSentences50 = faker.lorem.sentences(50).join('\n');
    final fakeSentences100 = faker.lorem.sentences(100).join('\n');

    RecipeVault.instance = FakeRecipeVault(initialRecipes: [
      Recipe.add(
        name: 'Pineapple',
        ingredients: fakeSentences50,
        description: fakeSentences50,
      ),
    ]);

    const myapp = ProviderScope(child: MyApp(initialRoute: '/home'));

    await tester.pumpWidget(myapp);
    await tester.pump();
    await tester.tap(find.text('Pineapple'));
    await tester.pumpAndSettle();

    expect(find.byKey(EditFoodViewState.scaffoldKey), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Pineapple'), findsOneWidget);

    final ingKey = find.byKey(EditFoodViewState.textIngrKey);
    final desKey = find.byKey(EditFoodViewState.textDescKey);
    await tester.enterText(ingKey, fakeSentences100);
    await tester.enterText(desKey, fakeSentences100);

    expect(
      find.widgetWithText(TextFormField, fakeSentences100),
      findsNWidgets(2),
    );
  });

  testWidgets('Cannot edit recipe without name', (WidgetTester tester) async {
    const myapp = ProviderScope(child: MyApp(initialRoute: '/home'));

    await tester.pumpWidget(myapp);
    await _addRecipe(tester, 'Pineapple');
    await tester.tap(find.text('Pineapple'));
    await tester.pumpAndSettle();

    expect(find.byKey(EditFoodViewState.scaffoldKey), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Pineapple'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Pineapple'), '');
    await tester.tap(find.byKey(EditFoodViewState.saveFoodKey));
    await tester.pumpAndSettle();

    expect(find.byKey(EditFoodViewState.scaffoldKey), findsOneWidget);
  });

  testWidgets('Can remove recipe', (WidgetTester tester) async {
    const myapp = ProviderScope(child: MyApp(initialRoute: '/home'));
    await tester.pumpWidget(myapp);

    await _addRecipe(tester, 'Pineapple');
    await tester.tap(find.text('Pineapple'));

    /// 1. Edit screen
    await tester.pumpAndSettle();
    expect(find.byKey(EditFoodViewState.scaffoldKey), findsOneWidget);

    /// 2. Tap on bin button
    await tester.tap(find.byKey(EditFoodViewState.delFoodKey));
    await tester.pump();

    /// 3. Show pop up to confirm
    expect(find.byType(AlertDialog), findsOneWidget);

    /// 4. * Tap yes
    await tester.tap(find.byKey(const Key('Yes')));

    /// 5. Item deleted and go back to home screen
    await tester.pumpAndSettle();
    expect(find.byKey(HomeViewMainContent.searchKey), findsOneWidget);
  });

  testWidgets('Can dismiss/cancel removal', (WidgetTester tester) async {
    const myapp = ProviderScope(child: MyApp(initialRoute: '/home'));
    await tester.pumpWidget(myapp);

    await _addRecipe(tester, 'Pineapple');
    await tester.tap(find.text('Pineapple'));

    /// 1. Edit screen
    await tester.pumpAndSettle();
    expect(find.byKey(EditFoodViewState.scaffoldKey), findsOneWidget);

    /// 2. Tap on bin button
    await tester.tap(find.byKey(EditFoodViewState.delFoodKey));
    await tester.pump();

    /// 3. Show pop up to confirm
    expect(find.byType(AlertDialog), findsOneWidget);

    /// 4. * Tap no
    await tester.tap(find.byKey(const Key('No')));
    expect(find.byKey(EditFoodViewState.scaffoldKey), findsOneWidget);
    await tester.pump();

    /// 5. Tap confirm to delete again
    await tester.tap(find.byKey(EditFoodViewState.delFoodKey));
    await tester.pump();
    expect(find.byType(AlertDialog), findsOneWidget);

    /// https://github.com/flutter/flutter/blob/master/packages/flutter/test/material/dialog_test.dart
    await tester.tapAt(const Offset(10.0, 10.0));
    await tester.pump();
    expect(find.byType(AlertDialog), findsNothing);
  });
}
