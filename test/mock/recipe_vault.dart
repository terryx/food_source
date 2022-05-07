import 'dart:convert';
import 'dart:io';
import 'package:food_source/controller/recipe.dart';
import 'package:file/memory.dart';
import 'package:food_source/model/recipe.dart';
import 'package:mockito/mockito.dart';

/// Reference 1 https://blog.victoreronmosele.com/mocking-filesystems-dart?x-host=blog.victoreronmosele.com
/// Reference 2 https://github.com/dart-lang/sdk/blob/f10a70ebda1672afa3feb1e970dcf4f1b5331467/pkg/front_end/test/memory_file_system_test.dart#L50
class MockRecipeVault extends Mock implements RecipeVault {
  MockRecipeVault({List<Recipe>? initialRecipes, String? contents})
      : _initialRecipes = initialRecipes,
        _contents = contents;

  final List<Recipe>? _initialRecipes;
  final String? _contents;

  @override
  Future<String> get localPath async {
    return 'kApplicationPath';
  }

  @override
  Future<File> get localFile async {
    final fileSystem = MemoryFileSystem();
    final file = fileSystem.file('recipes.txt');

    if (_initialRecipes != null) {
      final encoded = jsonEncode(_initialRecipes);
      file.writeAsString(encoded);
    } else if (_contents != null) {
      file.writeAsString(_contents!);
    }

    return file;
  }
}

class MockRecipeVault2 extends Mock implements RecipeVault {}
