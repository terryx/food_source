import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_source/controller/recipe.dart';
import 'package:food_source/localization.dart';
import 'package:food_source/model/recipe.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditFoodView extends StatefulHookConsumerWidget {
  const EditFoodView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => EditFoodViewState();
}

class EditFoodViewState extends ConsumerState<EditFoodView> {
  final _formKey = GlobalKey<FormState>();
  static const scaffoldKey = Key('EditFoodForm');
  static const textNameKey = Key('Name');
  static const textIngrKey = Key('Ingredients');
  static const textDescKey = Key('Description');
  static const saveFoodKey = Key('SaveFood');
  static const delFoodKey = Key('DeleteFood');

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Recipe;
    final nameController = useTextEditingController(text: args.name);
    final ingrController = useTextEditingController(text: args.ingredients);
    final descController = useTextEditingController(text: args.description);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(Lz.of(context)!.addFood),
        actions: [
          IconButton(
            key: delFoodKey,
            icon: const Icon(Icons.delete_rounded, color: Colors.redAccent),
            onPressed: () {
              ref.read(recipesProvider.notifier).remove(args.id);
              Navigator.pop(context);
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: saveFoodKey,
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            return;
          }

          await ref.read(recipesProvider.notifier).update(
                id: args.id,
                name: nameController.text,
                ingredients: ingrController.text,
                description: descController.text,
              );

          nameController.clear();
          ingrController.clear();
          descController.clear();

          Navigator.pop(context);
        },
        label: Text(Lz.of(context)!.save),
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                key: textNameKey,
                controller: nameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Lz.of(context)!.requiredText;
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                key: const Key('Ingredients'),
                controller: ingrController,
                minLines: 5,
                maxLines: 10,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Ingredients',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                key: const Key('Description'),
                controller: descController,
                minLines: 5,
                maxLines: 10,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
