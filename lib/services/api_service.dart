import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class ApiService {
  static const String baseUrl = 'https://api.edamam.com/api/recipes/v2';
  static const String appId = '9557bb51';
  static const String appKey = 'b616d00055f0f82d66f4ef6c799f7331';

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
}
