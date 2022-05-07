import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_source/controller/recipe.dart';
import 'package:food_source/localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddFoodView extends StatefulHookConsumerWidget {
  const AddFoodView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AddFoodViewState();
}

class AddFoodViewState extends ConsumerState<AddFoodView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final ingrController = useTextEditingController();
    final descController = useTextEditingController();

    return Scaffold(
      key: const Key('AddFoodForm'),
      appBar: AppBar(
        title: Text(Lz.of(context)!.addFood),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('SaveFood'),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            return;
          }

          await ref.read(recipesProvider.notifier).add(
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
                key: const Key('Name'),
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
