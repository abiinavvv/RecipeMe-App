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

  Future<Map<String, String?>> getUserProfile() async {
    return {
      'username':
          userProfileBox.get('username'),
      'email':
          userProfileBox.get('email'),
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
// import 'package:hive_flutter/hive_flutter.dart';
// import '../models/recipe.dart';
// import '../models/user.dart';

// class HiveService {
//   static const String usersBoxName = 'users';
//   static const String savedRecipesBoxName = 'savedRecipes';
//   static const String visitedRecipesBoxName = 'visitedRecipes';
//   static const String userRecipesBoxName = 'userRecipes';
//   static const String userProfileBoxName = 'userProfiles';
  
//   late Box<User> usersBox;
//   late Box<Map<dynamic, dynamic>> savedRecipesBox;
//   late Box<Map<dynamic, dynamic>> visitedRecipesBox;
//   late Box<Map<dynamic, dynamic>> userRecipesBox;
//   late Box<Map<dynamic, dynamic>> userProfilesBox;
  
//   Future<void> initHive() async {
//     await Hive.initFlutter();
    
//     // Register adapters
//     Hive.registerAdapter(UserAdapter());
//     Hive.registerAdapter(RecipeAdapter());
    
//     // Open boxes
//     usersBox = await Hive.openBox<User>(usersBoxName);
//     savedRecipesBox = await Hive.openBox<Map<dynamic, dynamic>>(savedRecipesBoxName);
//     visitedRecipesBox = await Hive.openBox<Map<dynamic, dynamic>>(visitedRecipesBoxName);
//     userRecipesBox = await Hive.openBox<Map<dynamic, dynamic>>(userRecipesBoxName);
//     userProfilesBox = await Hive.openBox<Map<dynamic, dynamic>>(userProfileBoxName);
//   }

//   // User Management Methods
//   Future<User?> createUser({
//     required String email,
//     required String username,
//     required String password,
//     String? profilePicturePath,
//   }) async {
//     try {
//       // Check if email already exists
//       if (await getUserByEmail(email) != null) {
//         throw Exception('User with this email already exists');
//       }

//       final user = User(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         email: email,
//         username: username,
//         password: password, // In production, ensure this is properly hashed
//         profilePicturePath: profilePicturePath,
//       );

//       await usersBox.put(user.id, user);
      
//       // Initialize empty collections for the new user
//       await savedRecipesBox.put(user.id, {});
//       await visitedRecipesBox.put(user.id, {});
//       await userRecipesBox.put(user.id, {});
//       await userProfilesBox.put(user.id, {
//         'username': username,
//         'email': email,
//         'profilePicture': profilePicturePath,
//       });

//       return user;
//     } catch (e) {
//       throw Exception('Failed to create user: $e');
//     }
//   }

//   Future<User?> getUserByEmail(String email) async {
//     try {
//       return usersBox.values.firstWhere(
//         (user) => user.email.toLowerCase() == email.toLowerCase(),
//         orElse: () => null as User,
//       );
//     } catch (e) {
//       throw Exception('Error getting user by email: $e');
//     }
//   }

//   Future<User?> getUserById(String userId) async {
//     try {
//       return usersBox.get(userId);
//     } catch (e) {
//       throw Exception('Error getting user by ID: $e');
//     }
//   }

//   Future<User?> authenticateUser(String email, String password) async {
//     try {
//       final user = await getUserByEmail(email);
//       if (user != null && user.password == password) { // In production, use proper password comparison
//         return user;
//       }
//       return null;
//     } catch (e) {
//       throw Exception('Authentication failed: $e');
//     }
//   }

//   // User Profile Management
//   Future<Map<String, dynamic>> getUserProfile({required String userId}) async {
//     try {
//       final profileData = userProfilesBox.get(userId);
//       if (profileData == null) {
//         final user = await getUserById(userId);
//         if (user == null) {
//           throw Exception('User not found');
//         }
//         // Create profile if it doesn't exist
//         final profile = {
//           'username': user.username,
//           'email': user.email,
//           'profilePicture': user.profilePicturePath,
//         };
//         await userProfilesBox.put(userId, profile);
//         return profile;
//       }
//       return Map<String, dynamic>.from(profileData);
//     } catch (e) {
//       throw Exception('Failed to get user profile: $e');
//     }
//   }

//   Future<void> updateUserProfile(String userId, {
//     String? username,
//     String? email,
//     String? profilePicturePath,
//   }) async {
//     try {
//       final user = await getUserById(userId);
//       if (user == null) {
//         throw Exception('User not found');
//       }

//       // Update user object
//       if (username != null) user.username = username;
//       if (email != null) user.email = email;
//       if (profilePicturePath != null) user.profilePicturePath = profilePicturePath;
//       await usersBox.put(userId, user);

//       // Update profile data
//       final currentProfile = await getUserProfile(userId: userId);
//       final updatedProfile = {
//         ...currentProfile,
//         if (username != null) 'username': username,
//         if (email != null) 'email': email,
//         if (profilePicturePath != null) 'profilePicture': profilePicturePath,
//       };
//       await userProfilesBox.put(userId, updatedProfile);
//     } catch (e) {
//       throw Exception('Failed to update user profile: $e');
//     }
//   }

//   // Recipe Management Methods
//   Future<void> saveRecipe(String userId, Recipe recipe) async {
//     try {
//       final userRecipes = await _getUserSavedRecipes(userId);
//       userRecipes[recipe.label] = recipe.toJson();
//       await savedRecipesBox.put(userId, userRecipes);
//     } catch (e) {
//       throw Exception('Failed to save recipe: $e');
//     }
//   }

//   Future<void> unsaveRecipe(String userId, Recipe recipe) async {
//     try {
//       final userRecipes = await _getUserSavedRecipes(userId);
//       userRecipes.remove(recipe.label);
//       await savedRecipesBox.put(userId, userRecipes);
//     } catch (e) {
//       throw Exception('Failed to unsave recipe: $e');
//     }
//   }

//   Future<List<Recipe>> getSavedRecipes(String userId) async {
//     try {
//       final userRecipes = await _getUserSavedRecipes(userId);
//       return userRecipes.values
//           .map((recipeJson) => Recipe.fromJson(Map<String, dynamic>.from(recipeJson)))
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to get saved recipes: $e');
//     }
//   }

//   Future<Map<dynamic, dynamic>> _getUserSavedRecipes(String userId) async {
//     return savedRecipesBox.get(userId) ?? {};
//   }

//   Future<void> addVisitedRecipe(String userId, Recipe recipe) async {
//     try {
//       final userVisited = await _getUserVisitedRecipes(userId);
//       recipe.visitedDate = DateTime.now();
//       userVisited[recipe.label] = recipe.toJson();
//       await visitedRecipesBox.put(userId, userVisited);
//     } catch (e) {
//       throw Exception('Failed to add visited recipe: $e');
//     }
//   }

//   Future<List<Recipe>> getVisitedRecipes(String userId) async {
//     try {
//       final userVisited = await _getUserVisitedRecipes(userId);
//       final recipes = userVisited.values
//           .map((recipeJson) => Recipe.fromJson(Map<String, dynamic>.from(recipeJson)))
//           .toList();
      
//       recipes.sort((a, b) => b.visitedDate!.compareTo(a.visitedDate!));
//       return recipes.take(10).toList(); // Return only the 10 most recent
//     } catch (e) {
//       throw Exception('Failed to get visited recipes: $e');
//     }
//   }

//   Future<Map<dynamic, dynamic>> _getUserVisitedRecipes(String userId) async {
//     return visitedRecipesBox.get(userId) ?? {};
//   }

//   // User Recipes Management
//   Future<void> addUserRecipe(String userId, Recipe recipe) async {
//     try {
//       final userRecipes = await _getUserCreatedRecipes(userId);
//       userRecipes[recipe.uri] = recipe.toJson();
//       await userRecipesBox.put(userId, userRecipes);
//     } catch (e) {
//       throw Exception('Failed to add user recipe: $e');
//     }
//   }

//   Future<void> updateUserRecipe(String userId, Recipe recipe) async {
//     try {
//       final userRecipes = await _getUserCreatedRecipes(userId);
//       userRecipes[recipe.uri] = recipe.toJson();
//       await userRecipesBox.put(userId, userRecipes);
//     } catch (e) {
//       throw Exception('Failed to update user recipe: $e');
//     }
//   }

//   Future<void> deleteUserRecipe(String userId, Recipe recipe) async {
//     try {
//       final userRecipes = await _getUserCreatedRecipes(userId);
//       userRecipes.remove(recipe.uri);
//       await userRecipesBox.put(userId, userRecipes);
//     } catch (e) {
//       throw Exception('Failed to delete user recipe: $e');
//     }
//   }

//   Future<List<Recipe>> getUserRecipes(String userId) async {
//     try {
//       final userRecipes = await _getUserCreatedRecipes(userId);
//       return userRecipes.values
//           .map((recipeJson) => Recipe.fromJson(Map<String, dynamic>.from(recipeJson)))
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to get user recipes: $e');
//     }
//   }

//   Future<Map<dynamic, dynamic>> _getUserCreatedRecipes(String userId) async {
//     return userRecipesBox.get(userId) ?? {};
//   }

//   // Cleanup Method
//   Future<void> clearUserData(String userId) async {
//     try {
//       await usersBox.delete(userId);
//       await savedRecipesBox.delete(userId);
//       await visitedRecipesBox.delete(userId);
//       await userRecipesBox.delete(userId);
//       await userProfilesBox.delete(userId);
//     } catch (e) {
//       throw Exception('Failed to clear user data: $e');
//     }
//   }
// }