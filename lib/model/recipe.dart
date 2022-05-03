
class Recipe {
  const Recipe({
    required this.name,
    this.ingredients,
    this.description,
});

  final String name;
  final String? ingredients;
  final String? description;
}