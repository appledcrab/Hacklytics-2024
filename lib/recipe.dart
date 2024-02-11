//recipe.dart
//contains the struture of the recipe class

class Recipe {
  final String title;
  final String imageUrl;
  final String recipeUrl;
  final String ingredients;
  final String diets;

  Recipe({
    required this.title,
    required this.imageUrl,
    this.recipeUrl = 'N/A',
    this.ingredients = 'N/A',
    this.diets = 'N/A',
  });
}
