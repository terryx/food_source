import 'package:flutter/material.dart';
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
    return Scaffold(
      key: const Key('AddFoodForm'),
      appBar: AppBar(
        title: Text(Lz.of(context)!.addFood),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {

                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Ingredients',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
