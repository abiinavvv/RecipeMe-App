import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class SavedRecipesScreen extends StatelessWidget {
  const SavedRecipesScreen({super.key});
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Saved Recipes',
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.savedRecipes.isEmpty) {
            return const Center(
              child: Text('No saved recipes yet.'),
            );
          }
          return ListView.builder(
            itemCount: appState.savedRecipes.length,
            itemBuilder: (context, index) {
              final recipe = appState.savedRecipes[index];
              return RecipeCard(
                title: recipe.label,
                imageUrl: recipe.image,
                source: recipe.source,
                recipe: recipe,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailScreen(recipe: recipe),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
