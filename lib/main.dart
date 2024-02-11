import 'package:flutter/material.dart';
import '/api_service.dart'; // Import the ApiService
import '/recipe.dart'; // Import the Recipe model
import 'Recipedetails.dart';

void main() {
  runApp(MaterialApp(
    title: 'Recipe Book App',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Recipe>> recipesFuture;
  String? selectedDietType; // Declare selectedDietType as nullable

  @override
  void initState() {
    super.initState();
    recipesFuture = ApiService.fetchRecipes('', 0, 20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Book'),
        actions: [
          DropdownButton<String>(
            value: selectedDietType,
            onChanged: (newValue) {
              setState(() {
                selectedDietType = newValue;
                recipesFuture = selectedDietType != null &&
                        selectedDietType!.isNotEmpty
                    ? ApiService.fetchRecipes(selectedDietType!, 0, 20)
                    : ApiService.fetchRecipes('', 0, 20); // Fetch all recipes
              });
            },
            items: <String>[
              '',
              'Balanced',
              'High-fiber',
              'High-protein',
              'Low-fat',
              'Low-sodium',
              'Vegan',
              'Low-carb',
              'Keto',
              'Paleo'
            ] // Include an empty item
                .map<DropdownMenuItem<String>>((String? value) {
              // Ensure the value is nullable
              return DropdownMenuItem<String>(
                value: value,
                child:
                    Text(value ?? 'All'), // Display 'All' for the empty value
              );
            }).toList(),
          ),
        ],
      ),
      body: FutureBuilder<List<Recipe>>(
        future: recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Recipe> recipes = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipeDetailsScreen(recipe: recipe),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.network(
                            recipe.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            recipe.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
