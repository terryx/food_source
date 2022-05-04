import 'package:flutter/material.dart';
import 'package:food_source/controller/recipe.dart';
import 'package:food_source/localization.dart';
import 'package:food_source/widget/recipe_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends StatefulHookConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Flexible(
          child: TextField(
            decoration: InputDecoration(
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
        const Divider(height: 25, thickness: 0, color: Colors.white),
        const Flexible(
          child: Text(
            'Recipes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Divider(),
        Expanded(
          child: RecipeList(recipes: ref.read(recipesProvider)),
        ),
      ],
    );
  }

}
