// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/recipe.dart';
// import '../widgets/recipe_card.dart';
// import 'recipe_detail_screen.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final ApiService _apiService = ApiService();
//   final TextEditingController _searchController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final List<Recipe> _searchResults = [];
//   bool _isLoading = false;
//   bool _hasMore = true;
//   String _currentQuery = '';
//   int _currentPage = 0;
//   static const int _pageSize = 20;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_scrollListener);
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels ==
//         _scrollController.position.maxScrollExtent) {
//       if (!_isLoading && _hasMore) {
//         _loadMoreResults();
//       }
//     }
//   }

//   Future<void> _performSearch(String query) async {
//     if (query.isEmpty) return;

//     setState(() {
//       _isLoading = true;
//       _currentQuery = query;
//       _currentPage = 0;
//       _searchResults.clear();
//     });

//     await _fetchResults();
//   }

//   Future<void> _loadMoreResults() async {
//     if (_currentQuery.isNotEmpty) {
//       _currentPage++;
//       await _fetchResults();
//     }
//   }

//   Future<void> _fetchResults() async {
//     try {
//       final results = await _apiService.searchRecipes(
//           _currentQuery, _currentPage, _pageSize);
//       setState(() {
//         _searchResults.addAll(results);
//         _isLoading = false;
//         _hasMore = results.length == _pageSize;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to perform search')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search Recipes'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search for recipes...',
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.search),
//                   onPressed: () => _performSearch(_searchController.text),
//                 ),
//               ),
//               onSubmitted: _performSearch,
//             ),
//           ),
//           Expanded(
//             child: _searchResults.isEmpty && !_isLoading
//                 ? const Center(child: Text('No results found'))
//                 : ListView.builder(
//                     controller: _scrollController,
//                     itemCount: _searchResults.length + (_isLoading ? 1 : 0),
//                     itemBuilder: (context, index) {
//                       if (index == _searchResults.length) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//                       final recipe = _searchResults[index];
//                       return RecipeCard(
//                         title: recipe.label,
//                         imageUrl: recipe.image,
//                         source: recipe.source,
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   RecipeDetailScreen(recipe: recipe),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recipeme_app/models/app_state.dart';
import '../services/api_service.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Recipe> _searchResults = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String _currentQuery = '';
  int _currentPage = 0;
  static const int _pageSize = 20;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_isLoading && _hasMore) {
        _loadMoreResults();
      }
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _currentQuery = query;
      _currentPage = 0;
      _searchResults.clear();
    });

    await _fetchResults();
  }

  Future<void> _loadMoreResults() async {
    if (_currentQuery.isNotEmpty) {
      _currentPage++;
      await _fetchResults();
    }
  }

  Future<void> _fetchResults() async {
    try {
      final results = await _apiService.searchRecipes(
          _currentQuery, _currentPage, _pageSize);
      setState(() {
        _searchResults.addAll(results);
        _isLoading = false;
        _hasMore = results.length == _pageSize;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to perform search'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Search Recipes',
            style: TextStyle(
                color: appState.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: appState.isDarkMode
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for recipes...',
                    hintStyle: const TextStyle(color: Colors.black),
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.black),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchResults.clear();
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(70),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: _performSearch,
                ),
              ),
              Expanded(
                child: _searchResults.isEmpty && !_isLoading
                    ? Center(
                        child: Text(
                          'Start searching for delicious recipes!',
                          style: TextStyle(
                              color: appState.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _searchResults.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _searchResults.length) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            );
                          }
                          final recipe = _searchResults[index];
                          return FadeTransition(
                            opacity: _animation,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 8.0),
                              child: RecipeCard(
                                title: recipe.label,
                                imageUrl: recipe.image,
                                source: recipe.source,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RecipeDetailScreen(recipe: recipe),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
