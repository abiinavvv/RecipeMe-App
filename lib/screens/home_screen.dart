// import 'package:flutter/material.dart';
// import 'package:recipeme_app/screens/recipe_detail_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../widgets/recipe_card.dart';
// import '../services/api_service.dart';
// import '../models/recipe.dart';
// import 'package:shimmer/shimmer.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final ApiService _apiService = ApiService();
//   List<Recipe> _recipes = [];
//   bool _isLoading = false;
//   String _selectedCategory = 'Chicken'; // Default selected category
//   String _selectedSubcategory = 'All'; // Default subcategory
//   List<String> _categories = [
//     'Chicken', 'Beef', 'Fish', 'Egg', 'Cucumber', 'Prawns', 'Vegetables', 'Fruits', 'Spices', 'Dairy', 'Bread',
//   ]; // Initial categories

//   // Map to define subcategories based on the ingredient category
//   final Map<String, List<String>> _subcategoriesMap = {
//     'Chicken': ['All', 'Grilled', 'Fried', 'Roast', 'Stew'],
//     'Beef': ['All', 'Steak', 'Burger', 'Curry','Sandwich'],
//     'Fish': ['All', 'Grilled', 'Fried', 'Sushi',],
//     'Egg': ['All', 'Omelette', 'Boiled', 'Scrambled','Bulls eye'],
//     // Add more as needed
//   };

//   List<String> _currentSubcategories = []; // Default subcategories

//   @override
//   void initState() {
//     super.initState();
//     _loadCategories();
//     _loadRecipes(category: _selectedCategory); // Load recipes for default category
//     _currentSubcategories = _subcategoriesMap[_selectedCategory] ?? ['All']; // Initialize with default subcategories
//   }

//   Future<void> _loadRecipes({String category = '', String subcategory = 'All'}) async {
//     setState(() {
//       _isLoading = true;
//       _selectedCategory = category;
//       _selectedSubcategory = subcategory;
//     });

//     try {
//       final query = subcategory != 'All' ? '$category $subcategory' : category;
//       final recipes = await _apiService.searchRecipes(query, 0, 10);
//       setState(() {
//         _recipes = recipes;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to load recipes')),
//       );
//     }
//   }

//   Future<void> _saveCategories() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList('categories', _categories);
//   }

//   Future<void> _loadCategories() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>? savedCategories = prefs.getStringList('categories');
//     if (savedCategories != null && savedCategories.isNotEmpty) {
//       setState(() {
//         _categories = savedCategories;
//       });
//     }
//   }

//   void _addCategory(String newCategory) {
//     if (newCategory.isNotEmpty && !_categories.contains(newCategory)) {
//       setState(() {
//         _categories.add(newCategory);
//       });
//       _saveCategories(); // Save categories after adding a new one
//     }
//   }

//   Future<void> _showAddCategoryDialog() async {
//     final TextEditingController categoryController = TextEditingController();

//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Add New Category'),
//           content: TextField(
//             controller: categoryController,
//             decoration: const InputDecoration(hintText: 'Enter category name'),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); //  dialog
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _addCategory(categoryController.text.trim());
//                 Navigator.of(context).pop(); //  dialog
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildShimmerEffect() {
//     return ListView.builder(
//       itemCount: 5, // shimmer cards
//       itemBuilder: (context, index) {
//         return Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 5,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             height: 150,
//             width: double.infinity,
//           ),
//         );
//       },
//     );
//   }

//   void _selectCategory(String category) {
//     setState(() {
//       _selectedCategory = category;
//       _currentSubcategories = _subcategoriesMap[category] ?? ['All']; // Load related subcategories
//       _selectedSubcategory = _currentSubcategories.first; // Reset to the first subcategory
//     });
//     _loadRecipes(category: category, subcategory: _selectedSubcategory); // Load recipes for selected category and subcategory
//   }

//   void _selectSubcategory(String subcategory) {
//     setState(() {
//       _selectedSubcategory = subcategory; // Update selected subcategory
//     });
//     _loadRecipes(category: _selectedCategory, subcategory: subcategory);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Top section search bar
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const CircleAvatar(
//                     backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
//                   ),
//                   const SizedBox(width: 25),
//                   const Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Welcome', style: TextStyle(color: Colors.grey)),
//                       Text("How are you", style: TextStyle(fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     onPressed: () {}, // Handle notification
//                     icon: const Icon(Icons.notifications_outlined),
//                   ),
//                 ],
//               ),
//             ),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Material(
//                 elevation: 5,
//                 borderRadius: BorderRadius.circular(70),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Type ingredients',
//                     prefixIcon: const Icon(Icons.search, color: Colors.black),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(70)),
//                     filled: true,
//                     fillColor: Colors.white,
//                     contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   ),
//                   onSubmitted: (value) {
//                     _loadRecipes(category: value);
//                   },
//                 ),
//               ),
//             ),

//             // Category selection with scrollable chips
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("What's in your fridge?", style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 13),
//                   SizedBox(
//                     height: 50, // Fixed height to limit the visible area
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Wrap(
//                         spacing: 10.0, // Space between chips
//                         runSpacing: 10, // Add vertical spacing between lines if needed
//                         children: [
//                           ..._categories.map((ingredient) {
//                             final isSelected = ingredient == _selectedCategory;
//                             return GestureDetector(
//                               onTap: () => _selectCategory(ingredient),
//                               child: Chip(
//                                 label: Text(ingredient),
//                                 backgroundColor: isSelected ? Colors.orange : Colors.white,
//                                 elevation: isSelected ? 10 : 5,
//                                 shadowColor: Colors.black.withOpacity(0.7),
//                                 padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                               ),
//                             );
//                           }),
//                           GestureDetector(
//                             onTap: _showAddCategoryDialog,
//                             child: Chip(
//                               label: const Row(
//                                 children: [
//                                   Icon(Icons.add, size: 20),
//                                   SizedBox(width: 5),
//                                   Text('Add Category'),
//                                 ],
//                               ),
//                               backgroundColor: Colors.grey[300],
//                               elevation: 3,
//                               shadowColor: Colors.black.withOpacity(0.2),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // Subcategory chips in a horizontal scrollable line
//                   const SizedBox(height: 16),
//                   const Text("Recipe types",style: TextStyle(fontWeight: FontWeight.bold),),
//                   SizedBox(
//                     height: 50, // Fixed height to limit the visible area
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Wrap(spacing: 10.0,
//                       runSpacing: 10,
//                         children: [
//                           ..._currentSubcategories.map((subcategory) {
//                             final isSelected = subcategory == _selectedSubcategory;
//                             return GestureDetector(
//                               onTap: () => _selectSubcategory(subcategory),
//                               child: Chip(
//                                 label: Text(subcategory),
//                                 backgroundColor: isSelected ? Colors.orange : Colors.white,
//                                 elevation: isSelected ? 10 : 5,
//                                 shadowColor: Colors.black.withOpacity(0.7),
//                                 padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
//                               ),
//                             );
//                           }),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Recipes section
//             const Padding(
//               padding: EdgeInsets.all(10.0),
//               child: Text('Recipes', style: TextStyle(fontWeight: FontWeight.bold)),
//             ),
//             _isLoading
//                 ? Expanded(child: _buildShimmerEffect())
//                 : Expanded(
//                     child: ListView.builder(
//                       itemCount: _recipes.length,
//                       itemBuilder: (context, index) {
//                         final recipe = _recipes[index];
//                         return RecipeCard(
//                           title: recipe.label,
//                           imageUrl: recipe.image,
//                           source: recipe.source,
//                           onTap: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) => RecipeDetailScreen(recipe: recipe),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:recipeme_app/screens/recipe_detail_screen.dart';
// import 'package:recipeme_app/screens/profile_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../widgets/recipe_card.dart';
// import '../services/api_service.dart';
// import '../models/recipe.dart';
// import '../services/hive_service.dart';
// import 'package:shimmer/shimmer.dart';

// class HomeScreen extends StatefulWidget {
//   final HiveService hiveService;

//   const HomeScreen({super.key, required this.hiveService});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final ApiService _apiService = ApiService();
//   List<Recipe> _recipes = [];
//   bool _isLoading = false;
//   String _selectedCategory = 'Chicken'; // Default selected category
//   String _selectedSubcategory = 'All'; // Default subcategory
//   List<String> _categories = [
//     'Chicken', 'Beef', 'Fish', 'Egg', 'Cucumber', 'Prawns', 'Vegetables', 'Fruits', 'Spices', 'Dairy', 'Bread',
//   ]; // Initial categories
//   String? profilePicturePath;

//   // Map to define subcategories based on the ingredient category
//   final Map<String, List<String>> _subcategoriesMap = {
//     'Chicken': ['All', 'Grilled', 'Fried', 'Roast', 'Stew'],
//     'Beef': ['All', 'Steak', 'Burger', 'Curry','Sandwich'],
//     'Fish': ['All', 'Grilled', 'Fried', 'Sushi',],
//     'Egg': ['All', 'Omelette', 'Boiled', 'Scrambled','Bulls eye'],
//     // Add more as needed
//   };

//   List<String> _currentSubcategories = []; // Default subcategories

//   @override
//   void initState() {
//     super.initState();
//     _loadCategories();
//     _loadRecipes(category: _selectedCategory); // Load recipes for default category
//     _currentSubcategories = _subcategoriesMap[_selectedCategory] ?? ['All']; // Initialize with default subcategories
//     _loadUserProfile();
//   }

//   Future<void> _loadRecipes({String category = '', String subcategory = 'All'}) async {
//     setState(() {
//       _isLoading = true;
//       _selectedCategory = category;
//       _selectedSubcategory = subcategory;
//     });

//     try {
//       final query = subcategory != 'All' ? '$category $subcategory' : category;
//       final recipes = await _apiService.searchRecipes(query, 0, 10);
//       setState(() {
//         _recipes = recipes;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to load recipes')),
//       );
//     }
//   }

//   Future<void> _saveCategories() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList('categories', _categories);
//   }

//   Future<void> _loadCategories() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>? savedCategories = prefs.getStringList('categories');
//     if (savedCategories != null && savedCategories.isNotEmpty) {
//       setState(() {
//         _categories = savedCategories;
//       });
//     }
//   }

//   void _addCategory(String newCategory) {
//     if (newCategory.isNotEmpty && !_categories.contains(newCategory)) {
//       setState(() {
//         _categories.add(newCategory);
//       });
//       _saveCategories(); // Save categories after adding a new one
//     }
//   }

//   Future<void> _showAddCategoryDialog() async {
//     final TextEditingController categoryController = TextEditingController();

//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Add New Category'),
//           content: TextField(
//             controller: categoryController,
//             decoration: const InputDecoration(hintText: 'Enter category name'),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); //  dialog
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _addCategory(categoryController.text.trim());
//                 Navigator.of(context).pop(); //  dialog
//               },
//               child: const Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildShimmerEffect() {
//     return ListView.builder(
//       itemCount: 5, // shimmer cards
//       itemBuilder: (context, index) {
//         return Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: Container(
//             margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 5,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             height: 150,
//             width: double.infinity,
//           ),
//         );
//       },
//     );
//   }

//   void _selectCategory(String category) {
//     setState(() {
//       _selectedCategory = category;
//       _currentSubcategories = _subcategoriesMap[category] ?? ['All']; // Load related subcategories
//       _selectedSubcategory = _currentSubcategories.first; // Reset to the first subcategory
//     });
//     _loadRecipes(category: category, subcategory: _selectedSubcategory); // Load recipes for selected category and subcategory
//   }

//   void _selectSubcategory(String subcategory) {
//     setState(() {
//       _selectedSubcategory = subcategory; // Update selected subcategory
//     });
//     _loadRecipes(category: _selectedCategory, subcategory: subcategory);
//   }

//   Future<void> _loadUserProfile() async {
//     final userProfile = await widget.hiveService.getUserProfile();
//     setState(() {
//       profilePicturePath = userProfile['profilePicture'];
//     });
//   }

//   void _navigateToProfileScreen() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProfileScreen(hiveService: widget.hiveService),
//       ),
//     ).then((_) {
//       // Reload the user profile when returning from the ProfileScreen
//       _loadUserProfile();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Top section with avatar and search bar
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                     onTap: _navigateToProfileScreen,
//                     child: CircleAvatar(
//                       backgroundImage: profilePicturePath != null
//                           ? FileImage(File(profilePicturePath!))
//                           : null,
//                       child: profilePicturePath == null
//                           ? const Icon(Icons.person, color: Colors.white)
//                           : null,
//                     ),
//                   ),
//                   const SizedBox(width: 25),
//                   const Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Welcome', style: TextStyle(color: Colors.grey)),
//                       Text("How are you", style: TextStyle(fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     onPressed: () {}, // Handle notification
//                     icon: const Icon(Icons.notifications_outlined),
//                   ),
//                 ],
//               ),
//             ),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Material(
//                 elevation: 5,
//                 borderRadius: BorderRadius.circular(70),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Type ingredients',
//                     prefixIcon: const Icon(Icons.search, color: Colors.black),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(70)),
//                     filled: true,
//                     fillColor: Colors.white,
//                     contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   ),
//                   onSubmitted: (value) {
//                     _loadRecipes(category: value);
//                   },
//                 ),
//               ),
//             ),

//             // Category selection with scrollable chips
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("What's in your fridge?", style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 13),
//                   SizedBox(
//                     height: 50, // Fixed height to limit the visible area
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Wrap(
//                         spacing: 10.0, // Space between chips
//                         runSpacing: 10, // Add vertical spacing between lines if needed
//                         children: [
//                           ..._categories.map((ingredient) {
//                             final isSelected = ingredient == _selectedCategory;
//                             return GestureDetector(
//                               onTap: () => _selectCategory(ingredient),
//                               child: Chip(
//                                 label: Text(ingredient),
//                                 backgroundColor: isSelected ? Colors.orange : Colors.white,
//                                 elevation: isSelected ? 10 : 5,
//                                 shadowColor: Colors.black.withOpacity(0.7),
//                                 padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                               ),
//                             );
//                           }),
//                           GestureDetector(
//                             onTap: _showAddCategoryDialog,
//                             child: Chip(
//                               label: const Row(
//                                 children: [
//                                   Icon(Icons.add, size: 20),
//                                   SizedBox(width: 5),
//                                   Text('Add Category'),
//                                 ],
//                               ),
//                               backgroundColor: Colors.grey[300],
//                               elevation: 3,
//                               shadowColor: Colors.black.withOpacity(0.2),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // Subcategory chips in a horizontal scrollable line
//                   const SizedBox(height: 16),
//                   const Text("Recipe types", style: TextStyle(fontWeight: FontWeight.bold)),
//                   SizedBox(
//                     height: 50, // Fixed height to limit the visible area
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Wrap(
//                         spacing: 10.0,
//                         runSpacing: 10,
//                         children: [
//                           ..._currentSubcategories.map((subcategory) {
//                             final isSelected = subcategory == _selectedSubcategory;
//                             return GestureDetector(
//                               onTap: () => _selectSubcategory(subcategory),
//                               child: Chip(
//                                 label: Text(subcategory),
//                                 backgroundColor: isSelected ? Colors.orange : Colors.white,
//                                 elevation: isSelected ? 10 : 5,
//                                 shadowColor: Colors.black.withOpacity(0.7),
//                                 padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
//                               ),
//                             );
//                           }),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Recipes section
//             const Padding(
//               padding: EdgeInsets.all(10.0),
//               child: Text('Recipes', style: TextStyle(fontWeight: FontWeight.bold)),
//             ),
//             _isLoading
//                 ? Expanded(child: _buildShimmerEffect())
//                 : Expanded(
//                     child: ListView.builder(
//                       itemCount: _recipes.length,
//                       itemBuilder: (context, index) {
//                         final recipe = _recipes[index];
//                         return RecipeCard(
//                           title: recipe.label,
//                           imageUrl: recipe.image,
//                           source: recipe.source,
//                           onTap: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) => RecipeDetailScreen(recipe: recipe),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:recipeme_app/screens/chat_screen.dart';
import 'dart:io';
import 'package:recipeme_app/screens/recipe_detail_screen.dart';
import 'package:recipeme_app/screens/profile_screen.dart';
import 'package:recipeme_app/screens/shopping_list_screen.dart'; // Import ShoppingListScreen
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/recipe_card.dart';
import '../services/api_service.dart';
import '../models/recipe.dart';
import '../services/hive_service.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  final HiveService hiveService;

  const HomeScreen({super.key, required this.hiveService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String _selectedCategory = 'Chicken'; // Default selected category
  String _selectedSubcategory = 'All'; // Default subcategory
  List<String> _categories = [
    'Chicken',
    'Beef',
    'Fish',
    'Egg',
    'Cucumber',
    'Prawns',
    'Vegetables',
    'Fruits',
    'Spices',
    'Dairy',
    'Bread',
  ]; // Initial categories
  String? profilePicturePath;

  // Map to define subcategories based on the ingredient category
  final Map<String, List<String>> _subcategoriesMap = {
    'Chicken': ['All', 'Grilled', 'Fried', 'Roast', 'Stew'],
    'Beef': ['All', 'Steak', 'Burger', 'Curry', 'Sandwich'],
    'Fish': ['All','Grilled','Fried','Sushi',],
    'Egg': ['All', 'Omelette', 'Boiled', 'Scrambled', 'Bulls eye'],
    // Add more as needed
  };

  List<String> _currentSubcategories = []; // Default subcategories

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadRecipes(
        category: _selectedCategory); // Load recipes for default category
    _currentSubcategories = _subcategoriesMap[_selectedCategory] ??
        ['All']; // Initialize with default subcategories
    _loadUserProfile();
  }

  Future<void> _loadRecipes(
      {String category = '', String subcategory = 'All'}) async {
    setState(() {
      _isLoading = true;
      _selectedCategory = category;
      _selectedSubcategory = subcategory;
    });

    try {
      final query = subcategory != 'All' ? '$category $subcategory' : category;
      final recipes = await _apiService.searchRecipes(query, 0, 10);
      setState(() {
        _recipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load recipes')),
      );
    }
  }

  Future<void> _saveCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('categories', _categories);
  }

  Future<void> _loadCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedCategories = prefs.getStringList('categories');
    if (savedCategories != null && savedCategories.isNotEmpty) {
      setState(() {
        _categories = savedCategories;
      });
    }
  }

  void _addCategory(String newCategory) {
    if (newCategory.isNotEmpty && !_categories.contains(newCategory)) {
      setState(() {
        _categories.add(newCategory);
      });
      _saveCategories(); // Save categories after adding a new one
    }
  }

  Future<void> _showAddCategoryDialog() async {
    final TextEditingController categoryController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(hintText: 'Enter category name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addCategory(categoryController.text.trim());
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5, // shimmer cards
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            height: 150,
            width: double.infinity,
          ),
        );
      },
    );
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _currentSubcategories =
          _subcategoriesMap[category] ?? ['All']; // Load related subcategories
      _selectedSubcategory =
          _currentSubcategories.first; // Reset to the first subcategory
    });
    _loadRecipes(
        category: category,
        subcategory:
            _selectedSubcategory); // Load recipes for selected category and subcategory
  }

  void _selectSubcategory(String subcategory) {
    setState(() {
      _selectedSubcategory = subcategory; // Update selected subcategory
    });
    _loadRecipes(category: _selectedCategory, subcategory: subcategory);
  }

  Future<void> _loadUserProfile() async {
    final userProfile = await widget.hiveService.getUserProfile();
    setState(() {
      profilePicturePath = userProfile['profilePicture'];
    });
  }

  void _navigateToProfileScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(hiveService: widget.hiveService),
      ),
    ).then((_) {
      // Reload the user profile when returning from the ProfileScreen
      _loadUserProfile();
    });
  }

  // New function to navigate to ShoppingListScreen
  void _navigateToShoppingListScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const ShoppingListScreen(), // Ensure ShoppingListScreen is correctly implemented
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section with avatar and search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _navigateToProfileScreen,
                    child: CircleAvatar(
                      backgroundImage: profilePicturePath != null
                          ? FileImage(File(profilePicturePath!))
                          : null,
                      child: profilePicturePath == null
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 25),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome', style: TextStyle(color: Colors.grey)),
                      Text("How are you",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Spacer(),
                  // Replace Notifications IconButton with Shopping List IconButton
                  IconButton(
                    onPressed:
                        _navigateToShoppingListScreen, // Navigate to ShoppingListScreen
                    icon: const Icon(Icons.shopping_cart_outlined),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(70),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type ingredients',
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(70)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                  ),
                  onSubmitted: (value) {
                    _loadRecipes(category: value);
                  },
                ),
              ),
            ),

            // Category selection with scrollable chips
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("What's in your fridge?",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 13),
                  SizedBox(
                    height: 50, // Fixed height to limit the visible area
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 10.0, // Space between chips
                        runSpacing:
                            10, // Add vertical spacing between lines if needed
                        children: [
                          ..._categories.map((ingredient) {
                            final isSelected = ingredient == _selectedCategory;
                            return GestureDetector(
                              onTap: () => _selectCategory(ingredient),
                              child: Chip(
                                label: Text(ingredient),
                                backgroundColor:
                                    isSelected ? Colors.orange : Colors.white,
                                elevation: isSelected ? 10 : 5,
                                shadowColor: Colors.black.withOpacity(0.7),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                              ),
                            );
                          }),
                          GestureDetector(
                            onTap: _showAddCategoryDialog,
                            child: Chip(
                              label: const Row(
                                children: [
                                  Icon(Icons.add, size: 20),
                                  SizedBox(width: 5),
                                  Text('Add Category'),
                                ],
                              ),
                              backgroundColor: Colors.grey[300],
                              elevation: 3,
                              shadowColor: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Subcategory chips in a horizontal scrollable line
                  const SizedBox(height: 16),
                  const Text("Recipe types",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 50, // Fixed height to limit the visible area
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 10.0,
                        runSpacing: 10,
                        children: [
                          ..._currentSubcategories.map((subcategory) {
                            final isSelected =
                                subcategory == _selectedSubcategory;
                            return GestureDetector(
                              onTap: () => _selectSubcategory(subcategory),
                              child: Chip(
                                label: Text(subcategory),
                                backgroundColor:
                                    isSelected ? Colors.orange : Colors.white,
                                elevation: isSelected ? 10 : 5,
                                shadowColor: Colors.black.withOpacity(0.7),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Recipes section
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Recipes',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            _isLoading
                ? Expanded(child: _buildShimmerEffect())
                : Expanded(
                    child: ListView.builder(
                      itemCount: _recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = _recipes[index];
                        return RecipeCard(
                          title: recipe.label,
                          imageUrl: recipe.image,
                          source: recipe.source,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecipeDetailScreen(recipe: recipe),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatScreen()),
        );
      },
      child: const Icon(Icons.chat),
      ),
    );
  }
}
