// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/recipe.dart';

// class ApiService {
//   static const String baseUrl = 'https://api.edamam.com/api/recipes/v2';
//   static const String appId = '9557bb51';
//   static const String appKey = 'b616d00055f0f82d66f4ef6c799f7331';

//   Future<List<Recipe>> searchRecipes(
//       String query, int page, int pageSize) async {
//     final response = await http.get(Uri.parse(
//         '$baseUrl?type=public&q=$query&app_id=$appId&app_key=$appKey&from=${page * pageSize}&to=${(page + 1) * pageSize}'));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       List<Recipe> recipes = [];
//       for (var hit in data['hits']) {
//         recipes.add(Recipe.fromJson(hit['recipe']));
//       }
//       return recipes;
//     } else {
//       throw Exception('Failed to load recipes');
//     }
//   }
// }
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class ApiService {
  static const String baseUrl = 'https://api.edamam.com/api/recipes/v2';
  static const String appId = '9557bb51';
  static const String appKey = 'b616d00055f0f82d66f4ef6c799f7331';

  // List of common ingredients to get random recipes
  static const List<String> commonIngredients = [
    'chicken','beef','fish','pasta','rice',
    'potato','tomato','carrot','mushroom','broccoli',
    'egg','cheese','salmon','shrimp','tofu','spinach',
    'avocado','beans','quinoa','lentils'
  ];

  Future<List<Recipe>> searchRecipes(
      String query, int page, int pageSize) async {
    final response = await http.get(Uri.parse(
        '$baseUrl?type=public&q=$query&app_id=$appId&app_key=$appKey&from=${page * pageSize}&to=${(page + 1) * pageSize}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Recipe> recipes = [];
      for (var hit in data['hits']) {
        recipes.add(Recipe.fromJson(hit['recipe']));
      }
      return recipes;
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<List<Recipe>> getRandomRecipes(int count) async {
    // Get random ingredients
    final random = Random();
    final randomIngredients = List<String>.from(commonIngredients)..shuffle(random);
    final selectedIngredients = randomIngredients.take(3).toList();
    
    // Get recipes for each ingredient
    List<Recipe> allRecipes = [];
    for (var ingredient in selectedIngredients) {
      try {
        final response = await http.get(Uri.parse(
            '$baseUrl?type=public&q=$ingredient&app_id=$appId&app_key=$appKey&from=0&to=10'));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          for (var hit in data['hits']) {
            allRecipes.add(Recipe.fromJson(hit['recipe']));
          }
        }
      } catch (e) {
        print('Error fetching recipes for $ingredient: $e');
        continue;
      }
    }

    // Shuffle all recipes and take required count
    allRecipes.shuffle(random);
    return allRecipes.take(count).toList();
  }
}