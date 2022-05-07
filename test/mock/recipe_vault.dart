
import 'dart:io';
import 'package:food_source/controller/recipe.dart';
import 'package:file/memory.dart';
import 'package:mockito/mockito.dart';

/// Reference 1 https://blog.victoreronmosele.com/mocking-filesystems-dart?x-host=blog.victoreronmosele.com
/// Reference 2 https://github.com/dart-lang/sdk/blob/f10a70ebda1672afa3feb1e970dcf4f1b5331467/pkg/front_end/test/memory_file_system_test.dart#L50
class MockRecipeVault extends Mock implements RecipeVault {
  @override
  Future<String> get localPath async {
    return 'kApplicationPath';
  }

  @override
  Future<File> get localFile async {
    final fileSystem = MemoryFileSystem();
    final file = fileSystem.file('recipes.txt');

    return file;
  }
}