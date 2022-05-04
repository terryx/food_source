import 'package:food_source/model/recipe.dart';
import 'package:riverpod/riverpod.dart';

// An object that controls a list of [Recipe]
class RecipeState extends StateNotifier<List<Recipe>> {
  RecipeState([List<Recipe>? initialRecipes]) : super(initialRecipes ?? []);

  void add({required String name, String? ingredients, String? description}) {
    state = [
      ...state,
      Recipe.add(
        name: name,
        ingredients: ingredients,
        description: description,
      ),
    ];
  }
}

/// Params takes controller and an object
final recipesProvider = StateNotifierProvider<RecipeState, List<Recipe>>((ref) {
  return RecipeState();
});
