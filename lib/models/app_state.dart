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
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/user.dart';
// import '../models/recipe.dart';
// import '../services/hive_service.dart';

// class AppState with ChangeNotifier {
//   final HiveService _hiveService;
//   late SharedPreferences _prefs;
//   User? _currentUser;
//   List<Recipe> _savedRecipes = [];
//   List<Recipe> _userRecipes = [];
//   bool _isDarkMode = false;

//   AppState({required HiveService hiveService, required SharedPreferences prefs})
//       : _hiveService = hiveService,
//         _prefs = prefs {
//     _initPrefs();
//     _loadLastLoggedInUser();
//   }

//   User? get currentUser => _currentUser;
//   List<Recipe> get savedRecipes => _savedRecipes;
//   List<Recipe> get userRecipes => _userRecipes;
//   bool get isDarkMode => _isDarkMode;
//   bool get isUserLoggedIn => _currentUser != null;

//   Future<void> _initPrefs() async {
//     _prefs = await SharedPreferences.getInstance();
//     _loadDarkModePreference();
//   }

//   Future<void> _loadLastLoggedInUser() async {
//     final lastLoggedInEmail = _prefs.getString('lastLoggedInEmail');
//     if (lastLoggedInEmail != null) {
//       _currentUser = await _hiveService.getUserByEmail(lastLoggedInEmail);
//       if (_currentUser != null) {
//         await _loadUserData();
//       }
//     }
//   }

//   Future<void> _loadUserData() async {
//     if (_currentUser != null) {
//       _savedRecipes = await _hiveService.getSavedRecipes(_currentUser!.id);
//       _userRecipes = await _hiveService.getUserRecipes(_currentUser!.id);
//       notifyListeners();
//     }
//   }

//   Future<bool> login(String email, String password) async {
//     final user = await _hiveService.authenticateUser(email, password);
//     if (user != null) {
//       _currentUser = user;
//       await _prefs.setString('lastLoggedInEmail', email);
//       await _loadUserData();
//       return true;
//     }
//     return false;
//   }

//   Future<void> logout() async {
//     _currentUser = null;
//     _savedRecipes.clear();
//     _userRecipes.clear();
//     await _prefs.remove('lastLoggedInEmail');
//     notifyListeners();
//   }

//   Future<bool> register({
//     required String email,
//     required String username,
//     required String password,
//     String? profilePicturePath,
//   }) async {
//     try {
//       final user = await _hiveService.createUser(
//         email: email,
//         username: username,
//         password: password,
//         profilePicturePath: profilePicturePath,
//       );
//       if (user != null) {
//         _currentUser = user;
//         await _prefs.setString('lastLoggedInEmail', email);
//         notifyListeners();
//         return true;
//       }
//       return false;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<void> addSavedRecipe(Recipe recipe) async {
//     if (_currentUser != null && !_savedRecipes.contains(recipe)) {
//       await _hiveService.saveRecipe(_currentUser!.id, recipe);
//       _savedRecipes.add(recipe);
//       notifyListeners();
//     }
//   }

//   Future<void> removeSavedRecipe(Recipe recipe) async {
//     if (_currentUser != null) {
//       await _hiveService.unsaveRecipe(_currentUser!.id, recipe);
//       _savedRecipes.removeWhere((r) => r.uri == recipe.uri);
//       notifyListeners();
//     }
//   }

//   Future<void> addUserRecipe(Recipe recipe) async {
//     if (_currentUser != null) {
//       await _hiveService.addUserRecipe(_currentUser!.id, recipe);
//       _userRecipes.add(recipe);
//       notifyListeners();
//     }
//   }

//   Future<void> updateUserRecipe(Recipe updatedRecipe) async {
//     if (_currentUser != null) {
//       final index = _userRecipes.indexWhere((recipe) => recipe.uri == updatedRecipe.uri);
//       if (index != -1) {
//         await _hiveService.updateUserRecipe(_currentUser!.id, updatedRecipe);
//         _userRecipes[index] = updatedRecipe;
//         notifyListeners();
//       }
//     }
//   }

//   Future<void> deleteUserRecipe(Recipe recipe) async {
//     if (_currentUser != null) {
//       await _hiveService.deleteUserRecipe(_currentUser!.id, recipe);
//       _userRecipes.removeWhere((r) => r.uri == recipe.uri);
//       notifyListeners();
//     }
//   }

//   void _loadDarkModePreference() {
//     _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
//     notifyListeners();
//   }

//   Future<void> toggleDarkMode() async {
//     _isDarkMode = !_isDarkMode;
//     await _prefs.setBool('isDarkMode', _isDarkMode);
//     notifyListeners();
//   }
// }