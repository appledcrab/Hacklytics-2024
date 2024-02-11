import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'recipe.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              recipe.imageUrl,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _launchRecipeURL(recipe.recipeUrl);
                      },
                      child: Text('View Recipe'),
                    ),
                  ),
                  Text(
                    'Diets:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    recipe.diets,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Ingredients:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    recipe.ingredients.isNotEmpty
                        ? recipe.ingredients
                        : 'No ingredients available',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchRecipeURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
