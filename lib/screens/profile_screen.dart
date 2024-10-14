import 'package:flutter/material.dart';
import 'dart:io';
import 'package:recipeme_app/screens/recipe_detail_screen.dart';
import '../models/recipe.dart';
import '../services/hive_service.dart';
import '../widgets/custom_image_widget.dart';
import 'edit_profile_screen.dart';
import 'setting_screen.dart';

class ProfileScreen extends StatefulWidget {
  final HiveService hiveService;

  const ProfileScreen({super.key, required this.hiveService});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "John Doe";
  String email = "john.doe@example.com";
  String? profilePicturePath;
  List<Recipe> visitedRecipes = [];
  List<Recipe> userRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadVisitedRecipes();
    _loadUserRecipes();
  }

  Future<void> _loadUserProfile() async {
    final userProfile = await widget.hiveService.getUserProfile();
    setState(() {
      username = userProfile['username'] ?? "John Doe";
      email = userProfile['email'] ?? "john.doe@example.com";
      profilePicturePath = userProfile['profilePicture'];
    });
  }

  Future<void> _loadVisitedRecipes() async {
    final recipes = await widget.hiveService.getVisitedRecipes();
    setState(() {
      visitedRecipes = recipes;
    });
  }

  Future<void> _loadUserRecipes() async {
    final recipes = await widget.hiveService.getUserRecipes();
    setState(() {
      userRecipes = recipes;
    });
  }

  Future<void> _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          hiveService: widget.hiveService,
          initialUsername: username,
          initialEmail: email,
          initialProfilePicturePath: profilePicturePath,
        ),
      ),
    );

    if (result == true) {
      _loadUserProfile();
    }
  }

  Future<void> _navigateToSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: profilePicturePath != null
                  ? FileImage(File(profilePicturePath!))
                  : null,
              child: profilePicturePath == null
                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 10),
            Text(
              username,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              email,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _navigateToEditProfile,
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text(
                    'Edit Profile',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildRecipeSection('My Recipes', userRecipes, true),
            const SizedBox(height: 20),
            _buildRecipeSection(
                'Recently Visited Recipes', visitedRecipes, false),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeSection(
      String title, List<Recipe> recipes, bool isUserRecipe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return _buildRecipeCard(recipe, isUserRecipe);
          },
        ),
      ],
    );
  }

  Widget _buildRecipeCard(Recipe recipe, bool isUserRecipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(
              recipe: recipe,
              isEditable: isUserRecipe,
            ),
          ),
        ).then((result) {
          if (result == true) {
            _loadUserRecipes();
          }
        });
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: CustomImageWidget(
                  imageUrl: isUserRecipe ? null : recipe.image,
                  localImagePath: isUserRecipe ? recipe.image : null,
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
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isUserRecipe
                        ? 'Source: ${recipe.source}'
                        : 'Visited: ${recipe.visitedDate?.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
  }
}
