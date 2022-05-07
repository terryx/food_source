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
      separatorBuilder: (_, __) => const Divider(color: Colors.white24),
      itemBuilder: (BuildContext context, int index) {
        final Recipe item = recipes[index];

        return Card(
          color: Colors.greenAccent[100],
          elevation: 0.7,
          margin: const EdgeInsets.all(0),
          child: ListTile(
            title: Text(
              item.name,
              style: const TextStyle(color: Colors.black87),
            ),
            onTap: () => onTap(item),
          ),
        );
      },
    );
  }
}
