import 'package:flutter/material.dart';

import '../model/recipe.dart';

class RecipeList extends StatelessWidget {
  const RecipeList({
    Key? key,
    required this.recipes,
  }) : super(key: key);

  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: const ValueKey('recipe_list'),
      itemCount: recipes.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final Recipe item = recipes[index];

        return ListTile(
          title: Text(item.name),
          subtitle: Text(item.description ?? ''),
        );
      },
    );
  }
}
