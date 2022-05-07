import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

@immutable
class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    this.ingredients,
    this.description,
  });

  static add({required name, ingredients, description}) {
    return Recipe(
      id: _uuid.v4(),
      name: name,
      ingredients: ingredients,
      description: description,
    );
  }

  final String id;
  final String name;
  final String? ingredients;
  final String? description;

  Recipe.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        ingredients = json['ingredients'],
        description = json['description'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients,
      'description': description,
    };
  }
}
