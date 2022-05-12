import 'package:flutter/material.dart';
import 'package:food_source/controller/recipe.dart';
import 'package:food_source/localization.dart';
import 'package:food_source/widget/recipe_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Lz.of(context)!.title),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: HomeViewMainContent(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('AddFood'),
        onPressed: () => Navigator.pushNamed(context, '/add_food'),
        label: Text(Lz.of(context)!.addFood),
      ),
    );
  }
}

class HomeViewMainContent extends HookConsumerWidget {
  const HomeViewMainContent({Key? key}) : super(key: key);

  static const searchKey = Key('SearchRecipe');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Similar to RDBMS design, read from origin/replica, write to cache/database
    final originRecipes = ref.watch(recipesProvider);
    final searchRecipes = ref.watch(recipesSearcher); // warm cache
    final cacheRecipes = ref.watch(recipesCache); // cold cache

    return cacheRecipes.when(
      loading: () => const LinearProgressIndicator(),
      error: (err, stack) => const Text('Error'),
      data: (caches) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: TextField(
                key: searchKey,
                onChanged: (v) {
                  if (v.isEmpty) {
                    ref.read(recipesSearcher.notifier).restore(originRecipes);
                  } else {
                    ref.read(recipesSearcher.notifier).filter(v);
                  }
                },
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  ),
                  hintText: 'Enter a search term',
                ),
              ),
            ),
            const Flexible(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 16),
                child: Text(
                  'Recipes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: RecipeList(
                recipes: searchRecipes,
                onTap: (r) =>
                    Navigator.pushNamed(context, '/edit_food', arguments: r),
              ),
            ),
          ],
        );
      },
    );
  }
}
