import 'package:http/http.dart' as http;
import 'dart:convert';
import '/recipe.dart'; // Import your Recipe model

class ApiService {
  static const String _appId = ''; // Removed for upload
  static const String _appKey = ''; // Removed for upload

  static Future<List<Recipe>> fetchRecipes(
      String dietLabel, int from, int to) async {
    final url = Uri.parse(
        'https://api.edamam.com/api/recipes/v2?type=public&q=diet:$dietLabel&app_id=$_appId&app_key=$_appKey&from=$from&to=$to');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> hits = jsonData['hits'];

      // Parse each recipe object in the hits array
      List<Recipe> recipes = hits.map((hit) {
        final recipeData = hit['recipe'];
        final List<dynamic>? ingredientsList = recipeData['ingredientLines'];
        final List<dynamic>? dietsList = recipeData['dietLabels'];
        print(dietsList);
        return Recipe(
          recipeUrl: recipeData['url'],
          title: recipeData['label'],
          imageUrl: recipeData['image'],
          ingredients:
              ingredientsList != null ? ingredientsList.join('\n') : '',
          diets: dietsList != null ? dietsList.join(', ') : '',
        );
      }).toList();

      return recipes;
    } else {
      throw Exception('Failed to fetch recipes');
    }
  }
}
