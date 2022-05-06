import 'package:flutter/material.dart';

import '../model/recipe.dart';

typedef RecipeFunc = void Function(Recipe r);

class RecipeList extends StatelessWidget {
  const RecipeList({
    Key? key,
    required this.recipes,
    required this.onTap,
  }) : super(key: key);

  final List<Recipe> recipes;
  final RecipeFunc onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: const Key('RecipeList'),
      itemCount: recipes.length,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        final Recipe item = recipes[index];

        return ListTile(
          title: Text(item.name),
          subtitle: Text(item.description ?? ''),
          onTap: () => onTap(item),
        );
      },
    );
  }
}
