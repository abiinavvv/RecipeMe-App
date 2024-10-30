// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/recipe.dart';
// import '../models/app_state.dart';
// import '../models/shopping_list_provider.dart';
// import 'add_edit_recipe_screen.dart';

// class RecipeDetailScreen extends StatelessWidget {
//   final Recipe recipe;
//   final bool isEditable;

//   const RecipeDetailScreen({
//     super.key,
//     required this.recipe,
//     this.isEditable = false,
//   });

//   Future<void> _navigateToEditRecipe(BuildContext context) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AddEditRecipeScreen(recipe: recipe),
//       ),
//     );

//     if (result == true) {
//       Navigator.pop(context, true);
//     }
//   }

//   void _deleteRecipe(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Delete Recipe'),
//           content: const Text('Are you sure you want to delete this recipe?'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Delete'),
//               onPressed: () {
//                 Provider.of<AppState>(context, listen: false)
//                     .deleteUserRecipe(recipe);
//                 Navigator.of(context).pop(); // Close the dialog
//                 Navigator.of(context)
//                     .pop(true); // Return to previous screen and refresh
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _addToShoppingList(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Add to Shopping List'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: recipe.ingredientLines.map((ingredient) {
//                 return CheckboxListTile(
//                   title: Text(ingredient),
//                   value: false,
//                   onChanged: (bool? value) {
//                     if (value == true) {
//                       Provider.of<ShoppingListProvider>(context, listen: false)
//                           .addIngredient(ingredient);
//                     }
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Add Selected'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Added to shopping Cart')),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         actions: [
//           Consumer<AppState>(
//             builder: (context, appState, child) {
//               final isSaved = appState.savedRecipes.contains(recipe);
//               return Container(
//                 width: 100,
//                 height: 100,
//                 decoration: const BoxDecoration(
//                     color: Colors.white, shape: BoxShape.circle),
//                 child: IconButton(
//                   icon: Icon(
//                     isSaved ? Icons.favorite : Icons.favorite_border,
//                     color: Colors.black,
//                   ),
//                   onPressed: () {
//                     if (isSaved) {
//                       appState.removeSavedRecipe(recipe);
//                     } else {
//                       appState.addSavedRecipe(recipe);
//                     }
//                   },
//                 ),
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.shopping_cart, color: Colors.white),
//             onPressed: () => _addToShoppingList(context),
//           ),
//           if (isEditable) ...[
//             IconButton(
//               icon: const Icon(Icons.edit, color: Colors.white),
//               onPressed: () => _navigateToEditRecipe(context),
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete, color: Colors.white),
//               onPressed: () => _deleteRecipe(context),
//             ),
//           ],
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 recipe.image.startsWith('http')
//                     ? Image.network(
//                         recipe.image,
//                         width: double.infinity,
//                         height: 300,
//                         fit: BoxFit.cover,
//                       )
//                     : Image.file(
//                         File(recipe.image),
//                         width: double.infinity,
//                         height: 300,
//                         fit: BoxFit.cover,
//                       ),
//                 Container(
//                   height: 300,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.transparent,
//                         Colors.black.withOpacity(0.7),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 16,
//                   left: 16,
//                   right: 16,
//                   child: Text(
//                     recipe.label,
//                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Source: ${recipe.source}',
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           color: Colors.grey[600],
//                         ),
//                   ),
//                   const SizedBox(height: 24),
//                   Text(
//                     'Ingredients:',
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                   const SizedBox(height: 8),
//                   ...recipe.ingredientLines.map((ingredient) => Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 4),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text('•',
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold)),
//                             const SizedBox(width: 8),
//                             Expanded(child: Text(ingredient)),
//                             IconButton(
//                               icon: const Icon(Icons.add_shopping_cart, size: 20),
//                               onPressed: () {
//                                 Provider.of<ShoppingListProvider>(context, listen: false)
//                                     .addIngredient(ingredient);
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text('$ingredient added to shopping list')),
//                                 );
//                               },
//                             ),
//                           ],
//                         ),
//                       )),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../models/app_state.dart';
import '../models/shopping_list_provider.dart';
import '../services/hive_service.dart'; // Import your HiveService
import 'add_edit_recipe_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  final bool isEditable;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    this.isEditable = false,
  });

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  void initState() {
    super.initState();
    _addToVisitedRecipes();
  }

  Future<void> _addToVisitedRecipes() async {
    final hiveService = Provider.of<HiveService>(context, listen: false);
    await hiveService.addVisitedRecipe(widget.recipe);
  }

  Future<void> _navigateToEditRecipe(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditRecipeScreen(recipe: widget.recipe),
      ),
    );

    if (result == true) {
      Navigator.pop(context, true);
    }
  }

  void _deleteRecipe(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Recipe'),
          content: const Text('Are you sure you want to delete this recipe?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Provider.of<AppState>(context, listen: false)
                    .deleteUserRecipe(widget.recipe);
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context)
                    .pop(true); // Return to the previous screen and refresh
              },
            ),
          ],
        );
      },
    );
  }

  void _addToShoppingList(BuildContext context) {
    List<String> selectedIngredients = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add to Shopping List'),
          content: SingleChildScrollView(
            child: ListBody(
              children: widget.recipe.ingredientLines.map((ingredient) {
                bool isSelected = selectedIngredients.contains(ingredient);
                return CheckboxListTile(
                  title: Text(ingredient),
                  value: isSelected,
                  onChanged: (bool? value) {
                    if (value == true) {
                      selectedIngredients.add(ingredient);
                    } else {
                      selectedIngredients.remove(ingredient);
                    }
                    (context as Element).markNeedsBuild();
                  },
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add Selected'),
              onPressed: () {
                for (var ingredient in selectedIngredients) {
                  Provider.of<ShoppingListProvider>(context, listen: false)
                      .addIngredient(ingredient);
                }
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to shopping list')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Consumer<AppState>(
            builder: (context, appState, child) {
              final isSaved = appState.savedRecipes.contains(widget.recipe);
              return Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: IconButton(
                  icon: Icon(
                    isSaved ? Icons.favorite : Icons.favorite_border,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    if (isSaved) {
                      appState.removeSavedRecipe(widget.recipe);
                    } else {
                      appState.addSavedRecipe(widget.recipe);
                    }
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () => _addToShoppingList(context),
          ),
          if (widget.isEditable) ...[
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => _navigateToEditRecipe(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () => _deleteRecipe(context),
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                widget.recipe.image.startsWith('http')
                    ? Image.network(
                        widget.recipe.image,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(widget.recipe.image),
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Text(
                    widget.recipe.label,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Source: ${widget.recipe.source}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Ingredients:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ...widget.recipe.ingredientLines.map((ingredient) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('•',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            Expanded(child: Text(ingredient)),
                            IconButton(
                              icon: const Icon(Icons.add_shopping_cart, size: 20),
                              onPressed: () {
                                Provider.of<ShoppingListProvider>(context, listen: false)
                                    .addIngredient(ingredient);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('$ingredient added to shopping list')),
                                );
                              },
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
