import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipeme_app/services/hive_service.dart';
import 'recipe.dart';

class AppState with ChangeNotifier {
  final HiveService _hiveService;
  late SharedPreferences _prefs;
  List<Recipe> _savedRecipes = [];
  List<Recipe> _userRecipes = [];
  bool _isDarkMode = false;

  AppState({required HiveService hiveService, required SharedPreferences prefs})
      : _hiveService = hiveService,
        _prefs = prefs {
    _initPrefs();
    _loadSavedRecipes();
    _loadUserRecipes();
    _loadDarkModePreference();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _loadDarkModePreference();
  }

  List<Recipe> get savedRecipes => _savedRecipes;
  List<Recipe> get userRecipes => _userRecipes;
  bool get isDarkMode => _isDarkMode;

  Future<void> _loadSavedRecipes() async {
    _savedRecipes = await _hiveService.getSavedRecipes();
    notifyListeners();
  }

  Future<void> _loadUserRecipes() async {
    _userRecipes = await _hiveService.getUserRecipes();
    notifyListeners();
  }

  void _loadDarkModePreference() {
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> addSavedRecipe(Recipe recipe) async {
    if (!_savedRecipes.contains(recipe)) {
      await _hiveService.saveRecipe(recipe);
      _savedRecipes.add(recipe);
      notifyListeners();
    }
  }

  Future<void> removeSavedRecipe(Recipe recipe) async {
    await _hiveService.unsaveRecipe(recipe);
    _savedRecipes.removeWhere((r) => r.uri == recipe.uri);
    notifyListeners();
  }

  bool isRecipeSaved(Recipe recipe) {
    return _savedRecipes.any((r) => r.uri == recipe.uri);
  }

  Future<void> addUserRecipe(Recipe recipe) async {
    await _hiveService.addUserRecipe(recipe);
    _userRecipes.add(recipe);
    notifyListeners();
  }

  Future<void> updateUserRecipe(Recipe updatedRecipe) async {
    final index =
        _userRecipes.indexWhere((recipe) => recipe.uri == updatedRecipe.uri);
    if (index != -1) {
      await _hiveService.updateUserRecipe(updatedRecipe);
      _userRecipes[index] = updatedRecipe;
      notifyListeners();
    }
  }

  Future<void> deleteUserRecipe(Recipe recipe) async {
    await _hiveService.deleteUserRecipe(recipe);
    _userRecipes.removeWhere((r) => r.uri == recipe.uri);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}
