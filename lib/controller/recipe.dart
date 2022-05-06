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

  void update({
    required String id,
    required String name,
    String? ingredients,
    String? description,
  }) {
    final recipe = state.firstWhere((Recipe element) => element.id == id);
    state.removeWhere((Recipe element) => element.id == id);

    state = [
      ...state,
      Recipe(
        id: recipe.id,
        name: name,
        ingredients: ingredients,
        description: description,
      )
    ];
  }

  void remove(String id) {
    state = state.where((Recipe element) => element.id != id).toList();
  }
}

class RecipeSearchState extends StateNotifier<List<Recipe>> {
  RecipeSearchState([List<Recipe>? initialRecipes]) : super(initialRecipes ?? []);

  void filter(String v) {
    state = state.where((element) => element.name.contains(v)).toList();
  }

  void restore(List<Recipe> r) {
    state = r;
  }
}

// class RecipeSearchState extends

/// Params takes controller and an object
final recipesProvider = StateNotifierProvider<RecipeState, List<Recipe>>((ref) {
  return RecipeState();
});

final recipesSearcher = StateNotifierProvider<RecipeSearchState, List<Recipe>>((ref) {
  final originalRecipes = ref.watch(recipesProvider);

  return RecipeSearchState(originalRecipes);
});
