import 'package:flutter/material.dart';
import 'package:food_source/localization.dart';

class RecipeForm extends StatelessWidget {
  const RecipeForm({
    Key? key,
    required Key formKey,
    required this.nameController,
    required this.ingrController,
    required this.descController,
  })  : _formKey = formKey,
        super(key: key);

  final Key _formKey;
  static const textNameKey = Key('Name');
  static const textIngrKey = Key('Ingredients');
  static const textDescKey = Key('Description');

  final TextEditingController nameController;
  final TextEditingController ingrController;
  final TextEditingController descController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                key: textNameKey,
                controller: nameController,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: Lz.of(context)!.recipeName,
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
                key: textIngrKey,
                controller: ingrController,
                minLines: 5,
                maxLines: 10,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: Lz.of(context)!.recipeIngr,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                key: textDescKey,
                controller: descController,
                minLines: 5,
                maxLines: 10,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: Lz.of(context)!.recipeDesc,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
