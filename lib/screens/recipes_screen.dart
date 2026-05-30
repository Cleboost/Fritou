import 'package:flutter/material.dart';
import 'package:fritou/data/recipes_data.dart';
import 'package:fritou/widgets/recipe_card.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu_book_rounded, color: Color(0xFFFFB74D)),
        title: const Text('RECETTES SECRÈTES'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        physics: const BouncingScrollPhysics(),
        itemCount: staticRecipes.length,
        itemBuilder: (context, index) {
          final recipe = staticRecipes[index];
          return RecipeCard(recipe: recipe);
        },
      ),
    );
  }
}
