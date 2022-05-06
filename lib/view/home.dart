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
        backgroundColor: Colors.green,
      ),
    );
  }
}

class HomeViewMainContent extends HookConsumerWidget {
  const HomeViewMainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final originRecipes = ref.watch(recipesProvider);
    final recipes = ref.watch(recipesSearcher);

    return Column(
      children: <Widget>[
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
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
              const Divider(height: 25, thickness: 0, color: Colors.white),
              const Text(
                'Recipes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: RecipeList(recipes: recipes),
        ),
      ],
    );
  }
}
