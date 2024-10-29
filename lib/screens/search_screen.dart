// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:recipeme_app/models/app_state.dart';
// import '../services/api_service.dart';
// import '../models/recipe.dart';
// import '../widgets/recipe_card.dart';
// import 'recipe_detail_screen.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen>
//     with SingleTickerProviderStateMixin {
//   final ApiService _apiService = ApiService();
//   final TextEditingController _searchController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final List<Recipe> _searchResults = [];
//   bool _isLoading = false;
//   bool _hasMore = true;
//   String _currentQuery = '';
//   int _currentPage = 0;
//   static const int _pageSize = 20;
//   late AnimationController _animationController;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_scrollListener);
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _animation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     );
//     _animationController.forward();
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
//         SnackBar(
//           content: const Text('Failed to perform search'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final appState = Provider.of<AppState>(context);
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: Text('Search Recipes',
//             style: TextStyle(
//                 color: appState.isDarkMode ? Colors.white : Colors.black,
//                 fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         systemOverlayStyle: appState.isDarkMode
//             ? SystemUiOverlayStyle.dark
//             : SystemUiOverlayStyle.light,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(),
//         child: SafeArea(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: TextField(
//                   controller: _searchController,
//                   decoration: InputDecoration(
//                     hintText: 'Search for recipes...',
//                     hintStyle: const TextStyle(color: Colors.black),
//                     prefixIcon: const Icon(Icons.search, color: Colors.black),
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.clear, color: Colors.black),
//                       onPressed: () {
//                         _searchController.clear();
//                         setState(() {
//                           _searchResults.clear();
//                         });
//                       },
//                     ),
//                     filled: true,
//                     fillColor: Colors.grey[300],
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(70),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(vertical: 0),
//                   ),
//                   style: const TextStyle(color: Colors.white),
//                   onSubmitted: _performSearch,
//                 ),
//               ),
//               Expanded(
//                 child: Stack(
//                   children: [
//                     _searchResults.isEmpty && !_isLoading
//                         ? Center(
//                             child: Text(
//                               'Start searching for delicious recipes!',
//                               style: TextStyle(
//                                   color: appState.isDarkMode
//                                       ? Colors.white
//                                       : Colors.black,
//                                   fontSize: 18),
//                             ),
//                           )
//                         : ListView.builder(
//                             controller: _scrollController,
//                             itemCount: _searchResults.length,
//                             itemBuilder: (context, index) {
//                               final recipe = _searchResults[index];
//                               return FadeTransition(
//                                 opacity: _animation,
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 12.0, vertical: 8.0),
//                                   child: RecipeCard(
//                                     title: recipe.label,
//                                     imageUrl: recipe.image,
//                                     source: recipe.source,
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               RecipeDetailScreen(recipe: recipe),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                     if (_isLoading)
//                       const Center(
//                         child: CircularProgressIndicator(
//                           valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _scrollController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../models/app_state.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';
import '../widgets/custom_image_widget.dart';
import 'recipe_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final HiveService hiveService;

  const SearchScreen({super.key, required this.hiveService});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Constants
  static const int _pageSize = 20;
  static const Duration _searchDebounce = Duration(milliseconds: 500);

  // Services
  final ApiService _apiService = ApiService();

  // Controllers
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // State variables
  final List<Recipe> _searchResults = [];
  List<Recipe> _visitedRecipes = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String _currentQuery = '';
  int _currentPage = 0;

  // Debounce timer
  Timer? _searchDebounceTimer;

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
    _loadVisitedRecipes();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreIfNeeded();
      }
    });
  }

  Future<void> _loadVisitedRecipes() async {
    try {
      final recipes = await widget.hiveService.getVisitedRecipes();
      setState(() {
        _visitedRecipes = recipes.reversed.take(6).toList();
      });
    } catch (e) {
      _showError('Failed to load recent recipes');
    }
  }

  void _handleSearch(String query) {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(_searchDebounce, () {
      if (query.isEmpty) {
        setState(() {
          _searchResults.clear();
          _currentQuery = '';
          _currentPage = 0;
          _hasMore = true;
        });
        return;
      }
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query == _currentQuery) return;

    setState(() {
      _isLoading = true;
      _currentQuery = query;
      _currentPage = 0;
      _searchResults.clear();
    });

    await _fetchResults();
  }

  Future<void> _loadMoreIfNeeded() async {
    if (!_isLoading && _hasMore && _currentQuery.isNotEmpty) {
      _currentPage++;
      await _fetchResults();
    }
  }

  Future<void> _fetchResults() async {
    try {
      setState(() => _isLoading = true);
      final results = await _apiService.searchRecipes(
        _currentQuery,
        _currentPage,
        _pageSize,
      );
      
      setState(() {
        _searchResults.addAll(results);
        _hasMore = results.length == _pageSize;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Failed to perform search');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            _buildSearchAppBar(),
          ],
          body: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildSearchAppBar() {
    final appState = Provider.of<AppState>(context);
    
    return SliverAppBar(
      floating: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      expandedHeight: 100,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
          child: _SearchBar(
            controller: _searchController,
            onChanged: _handleSearch,
            isDarkMode: appState.isDarkMode,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _searchResults.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty) {
      return _RecentRecipesGrid(
        recipes: _visitedRecipes,
        onRecipeTap: _navigateToRecipeDetail,
      );
    }

    return _SearchResultsList(
      results: _searchResults,
      scrollController: _scrollController,
      isLoading: _isLoading,
      onRecipeTap: _navigateToRecipeDetail,
    );
  }

  void _navigateToRecipeDetail(Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchDebounceTimer?.cancel();
    super.dispose();
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool isDarkMode;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search for recipes...',
        hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
        prefixIcon: Icon(Icons.search, color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear, color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
          onPressed: () {
            controller.clear();
            onChanged('');
          },
        ),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.zero,
      ),
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }
}

class _RecentRecipesGrid extends StatelessWidget {
  final List<Recipe> recipes;
  final ValueChanged<Recipe> onRecipeTap;

  const _RecentRecipesGrid({
    required this.recipes,
    required this.onRecipeTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Text(
              'Popular Recipes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final recipe = recipes[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () => onRecipeTap(recipe),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: CustomImageWidget(
                              imageUrl: recipe.image,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe.label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                recipe.source,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: recipes.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchResultsList extends StatelessWidget {
  final List<Recipe> results;
  final ScrollController scrollController;
  final bool isLoading;
  final ValueChanged<Recipe> onRecipeTap;

  const _SearchResultsList({
    required this.results,
    required this.scrollController,
    required this.isLoading,
    required this.onRecipeTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: results.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == results.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final recipe = results[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () => onRecipeTap(recipe),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(12),
                    ),
                    child: CustomImageWidget(
                      imageUrl: recipe.image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.label,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            recipe.source,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}