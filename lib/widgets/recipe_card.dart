// import 'package:flutter/material.dart';

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
//       elevation: 4, // Adjust elevation for shadow depth
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15), // Rounded corners
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius:
//             BorderRadius.circular(15), // Ensure InkWell has rounded corners
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AspectRatio(
//               aspectRatio: 16 / 9, // Adjust aspect ratio as needed
//               child: ClipRRect(
//                 borderRadius:
//                     const BorderRadius.vertical(top: Radius.circular(15)),
//                 child: Image.network(
//                   imageUrl,
//                   fit: BoxFit.cover,
//                   loadingBuilder: (BuildContext context, Widget child,
//                       ImageChunkEvent? loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return Center(
//                       child: CircularProgressIndicator(
//                         value: loadingProgress.expectedTotalBytes != null
//                             ? loadingProgress.cumulativeBytesLoaded /
//                                 (loadingProgress.expectedTotalBytes ?? 1)
//                             : null,
//                       ),
//                     );
//                   },
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       color: Colors.grey[200], // Placeholder background color
//                       child: const Icon(Icons.error), // Placeholder icon
//                     );
//                   },
//                 ),
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
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16), // Adjust font size as needed
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Source: $source',
//                     style: const TextStyle(
//                         color: Colors.grey,
//                         fontSize: 14), // Adjust font size as needed
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

class RecipeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String source;
  final VoidCallback onTap;

  const RecipeCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.source,
    required this.onTap, 
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
                      height: 180, // Set a fixed height for the card
                    ),
                  ),
                  // Actual image loading
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover, // Cover the entire space
                    height: 180, // Set the same fixed height
                    width: double.infinity, // Ensure it takes full width
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(); // Do not show progress indicator
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.error),
                      );
                    },
                  ),
                ],
              ),
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
