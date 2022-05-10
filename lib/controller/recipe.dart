import 'dart:convert';
import 'dart:io';

import 'package:food_source/model/recipe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';

/// 1. Support riverpod provider
/// 2. Support device disk access
/// 3. Support a separated search for cleaner data manipulation
class _RecipeVaultProvider extends RecipeVault {}

/// TODO: https://stackoverflow.com/questions/62597011/mock-getexternalstoragedirectory-on-flutter
/// Not going to mock this until Flutter standardised for common platform behaviour
abstract class RecipeVault {
  static RecipeVault instance = _RecipeVaultProvider();

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get localFile async {
    final path = await localPath;

    return File('$path/recipes.txt');
  }
}

Future<List<Recipe>> _readFile() async {
  try {
    final file = await RecipeVault.instance.localFile;

    final contents = await file.readAsString();
    final List<dynamic> caches = await json.decode(contents);
    final results = caches.map((e) => Recipe.fromJson(e)).toList();

    return results;
  } catch (e) {
    return [];
  }
}

Future<void> _writeFile(List<Recipe> state) async {
  final file = await RecipeVault.instance.localFile;
  final encoded = jsonEncode(state);

  await file.writeAsString(encoded);
}

// An object that controls a list of [Recipe]
class RecipeState extends StateNotifier<List<Recipe>> {
  RecipeState([List<Recipe>? initialRecipes]) : super(initialRecipes ?? []);

  Future<void> add(
      {required String name, String? ingredients, String? description}) async {
    state = [
      Recipe.add(
        name: name,
        ingredients: ingredients,
        description: description,
      ),
      ...state
    ];

    await _writeFile(state);
  }

  Future<void> update({
    required String id,
    required String name,
    String? ingredients,
    String? description,
  }) async {
    final recipe = state.firstWhere((Recipe element) => element.id == id);
    state.removeWhere((Recipe element) => element.id == id);

    state = [
      Recipe(
        id: recipe.id,
        name: name,
        ingredients: ingredients,
        description: description,
      ),
      ...state
    ];

    await _writeFile(state);
  }

  Future<void> remove(String id) async {
    state = state.where((Recipe element) => element.id != id).toList();

    await _writeFile(state);
  }
}

class RecipeSearchState extends StateNotifier<List<Recipe>> {
  RecipeSearchState([List<Recipe>? initialRecipes])
      : super(initialRecipes ?? []);

  void filter(String v) {
    final sanitised = v.toLowerCase();

    state = state
        .where((element) => element.name.toLowerCase().contains(sanitised))
        .toList();
  }

  void restore(List<Recipe> r) {
    state = r;
  }
}

/// In-memory data source
final recipesProvider = StateNotifierProvider<RecipeState, List<Recipe>>((ref) {
  return RecipeState();
});

/// Cache from disk
/// https://riverpod.dev/docs/providers/future_provider
final recipesCache = FutureProvider<List<Recipe>>((ref) async {
  final caches = await _readFile();
  ref.read(recipesProvider).addAll(caches);

  return caches;
});

/// In-memory data source for search
final recipesSearcher =
    StateNotifierProvider<RecipeSearchState, List<Recipe>>((ref) {
  final originalRecipes = ref.watch(recipesProvider);

  return RecipeSearchState(originalRecipes);
});
