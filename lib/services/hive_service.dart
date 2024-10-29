import 'package:hive_flutter/hive_flutter.dart';
import '../models/recipe.dart';

class HiveService {
  static const String savedRecipesBoxName = 'savedRecipes';
  static const String visitedRecipesBoxName = 'visitedRecipes';
  static const String userProfileBoxName = 'userProfile';
  static const String userRecipesBoxName = 'user_recipes';

  late Box<Recipe> savedRecipesBox;
  late Box<Recipe> visitedRecipesBox;
  late Box userProfileBox;
  late Box<Recipe> userRecipesBox;

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(RecipeAdapter());

    savedRecipesBox = await Hive.openBox<Recipe>(savedRecipesBoxName);
    visitedRecipesBox = await Hive.openBox<Recipe>(visitedRecipesBoxName);
    userProfileBox = await Hive.openBox(userProfileBoxName);
    userRecipesBox = await Hive.openBox<Recipe>(userRecipesBoxName);
  }

  Future<void> saveRecipe(Recipe recipe) async {
    try {
      await savedRecipesBox.put(recipe.label,recipe);
    } catch (e) {
      print("Error saving recipe: $e");
    }
  }

  Future<void> unsaveRecipe(Recipe recipe) async {
    await savedRecipesBox.delete(recipe.label);
  }

  Future<List<Recipe>> getSavedRecipes() async {
    return savedRecipesBox.values.toList();
  }

  Future<bool> isRecipeSaved(String recipeId) async {
    return savedRecipesBox.containsKey(recipeId);
  }

  Future<void> addVisitedRecipe(Recipe recipe) async {
    recipe.visitedDate = DateTime.now();
    await visitedRecipesBox.put(recipe.label, recipe);
  }

  Future<List<Recipe>> getVisitedRecipes() async {
    final recipes = visitedRecipesBox.values.toList();
    recipes.sort((a, b) => b.visitedDate!.compareTo(a.visitedDate!));
    return recipes
        .take(10)
        .toList(); // show only the 10 most recently visited recipes
  }

  Future<void> saveUserProfile({
    required String username,
    required String email,
    String? profilePicturePath,
  }) async {
    await userProfileBox.put('username', username);
    await userProfileBox.put('email', email);
    if (profilePicturePath != null) {
      await userProfileBox.put('profilePicture', profilePicturePath);
    }
  }

  Future<Map<String, String>> getUserProfile() async {
    return {
      'username':
          userProfileBox.get('username', defaultValue: 'Abhinav Aneesh'),
      'email':
          userProfileBox.get('email', defaultValue: 'abhinavaneesh2@gmail.com'),
      'profilePicture': userProfileBox.get('profilePicture'),
    };
  }

  Future<List<Recipe>> getUserRecipes() async {
    return userRecipesBox.values.toList();
  }

  Future<void> addUserRecipe(Recipe recipe) async {
    await userRecipesBox.put(recipe.uri, recipe);
  }

  Future<void> updateUserRecipe(Recipe recipe) async {
    await userRecipesBox.put(recipe.uri, recipe);
  }

  Future<void> deleteUserRecipe(Recipe recipe) async {
    await userRecipesBox.delete(recipe.uri);
  }
}
