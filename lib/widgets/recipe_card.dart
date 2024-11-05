// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// class RecipeCard extends StatelessWidget {
//   final String title;
//   final String imageUrl;
//   final String source;
//   final VoidCallback onTap;

//   const RecipeCard({
//     super.key,
//     required this.title,
//     required this.imageUrl,
//     required this.source,
//     required this.onTap, 
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(16),
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius:
//                   const BorderRadius.vertical(top: Radius.circular(15)),
//               child: Stack(
//                 children: [
//                   // Shimmer effect placeholder
//                   Shimmer.fromColors(
//                     baseColor: Colors.grey[300]!,
//                     highlightColor: Colors.grey[100]!,
//                     child: Container(
//                       color: Colors.white,
//                       height: 180, // Set a fixed height for the card
//                     ),
//                   ),
//                   // Actual image loading
//                   Image.network(
//                     imageUrl,
//                     fit: BoxFit.cover, // Cover the entire space
//                     height: 180, // Set the same fixed height
//                     width: double.infinity, // Ensure it takes full width
//                     loadingBuilder: (BuildContext context, Widget child,
//                         ImageChunkEvent? loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Container(); // Do not show progress indicator
//                     },
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         color: Colors.grey[200],
//                         child: const Icon(Icons.image),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Source: $source',
//                     style: const TextStyle(color: Colors.grey, fontSize: 14),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../models/app_state.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String source;
  final VoidCallback onTap;
  final Recipe recipe; // Add this field for the full recipe data

  const RecipeCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.source,
    required this.onTap,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Stack(
                    children: [
                      // Shimmer effect placeholder
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.white,
                          height: 180,
                        ),
                      ),
                      // Actual image loading
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: 180,
                        width: double.infinity,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container();
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Save button positioned at the top-right corner
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<AppState>(
                    builder: (context, appState, child) {
                      final isSaved = appState.isRecipeSaved(recipe);
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            if (isSaved) {
                              await appState.removeSavedRecipe(recipe);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Recipe removed from saved recipes'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              await appState.addSavedRecipe(recipe);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Recipe saved successfully'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              isSaved ? Icons.favorite : Icons.favorite_border_outlined,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Source: $source',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}