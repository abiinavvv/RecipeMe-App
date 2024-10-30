import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipeme_app/screens/add_edit_recipe_screen.dart';
import 'package:recipeme_app/screens/splash_screen.dart';
import 'services/hive_service.dart';
import 'models/app_state.dart';
import 'screens/home_screen.dart';
import 'screens/saved_recipes_screen.dart';
import 'screens/search_screen.dart';
import 'screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'models/shopping_list_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hiveService = HiveService();
  await hiveService.initHive();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                AppState(hiveService: hiveService, prefs: prefs)),
                ChangeNotifierProvider(create: (context) => ShoppingListProvider()),
        Provider<HiveService>.value(value: hiveService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'RecipeMe',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home:  const SplashScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hiveService = Provider.of<HiveService>(context, listen: false);
    final appState = Provider.of<AppState>(context);
    final List<Widget> widgetOptions = <Widget>[
      HomeScreen(hiveService: hiveService,),
     SearchScreen(hiveService: hiveService,),
      const AddEditRecipeScreen(),
      const SavedRecipesScreen(),
      ProfileScreen(hiveService: hiveService),
    ];

    return Scaffold(
      body: Center(
        child: widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 65,
        items: <Widget>[
          Icon(Icons.home,
              size: 30,
              color: appState.isDarkMode ? Colors.white : Colors.orange),
          Icon(Icons.search_rounded,
              size: 30,
              color: appState.isDarkMode ? Colors.white : Colors.orange),
          Icon(Icons.add_circle_outline_outlined,
              size: 30,
              color: appState.isDarkMode ? Colors.white : Colors.orange),
          Icon(Icons.favorite,
              size: 30,
              color: appState.isDarkMode ? Colors.white : Colors.orange),
          Icon(Icons.person_rounded,
              size: 30,
              color: appState.isDarkMode ? Colors.white : Colors.orange),
        ],
        color: appState.isDarkMode ? Colors.black : Colors.white,
        buttonBackgroundColor:
            appState.isDarkMode ? Colors.orange : Colors.orange[200],
        backgroundColor: appState.isDarkMode ? Colors.black : Colors.white,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          if (index == 2) {
            // navigate to add recipe
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddEditRecipeScreen()),
            );
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:recipeme_app/screens/add_edit_recipe_screen.dart';
// import 'package:recipeme_app/screens/login_screen.dart';
// import 'package:recipeme_app/screens/register_screen.dart';
// import 'services/hive_service.dart';
// import 'models/app_state.dart';
// import 'screens/home_screen.dart';
// import 'screens/saved_recipes_screen.dart';
// import 'screens/search_screen.dart';
// import 'screens/profile_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'models/shopping_list_provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   final hiveService = HiveService();
//   await hiveService.initHive();
//   final prefs = await SharedPreferences.getInstance();

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (context) => AppState(hiveService: hiveService, prefs: prefs),
//         ),
//         ChangeNotifierProvider(create: (context) => ShoppingListProvider()),
//         Provider<HiveService>.value(value: hiveService),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AppState>(
//       builder: (context, appState, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: 'RecipeMe',
//           theme: ThemeData.light(),
//           darkTheme: ThemeData.dark(),
//           themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
//           home: const AuthWrapper(),
//           routes: {
//             '/login': (context) => const LoginScreen(),
//             '/register': (context) => const RegisterScreen(),
//             '/main': (context) => const MainScreen(),
//           },
//         );
//       },
//     );
//   }
// }

// // New AuthWrapper widget to handle authentication state
// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AppState>(
//       builder: (context, appState, _) {
//         if (appState.isUserLoggedIn) {
//           return const MainScreen();
//         } else {
//           return const LoginScreen();
//         }
//       },
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   MainScreenState createState() => MainScreenState();
// }

// class MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     final hiveService = Provider.of<HiveService>(context, listen: false);
//     final appState = Provider.of<AppState>(context);

//     // Check if user is logged in, if not redirect to login
//     if (!appState.isUserLoggedIn) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Navigator.of(context).pushReplacementNamed('/login');
//       });
//       return const SizedBox.shrink();
//     }

//     final List<Widget> widgetOptions = <Widget>[
//       HomeScreen(hiveService: hiveService),
//       SearchScreen(hiveService: hiveService),
//       const AddEditRecipeScreen(),
//       const SavedRecipesScreen(),
//       ProfileScreen(hiveService: hiveService),
//     ];

//     return Scaffold(
//       appBar: _selectedIndex == 4 ? AppBar(
//         title: const Text('Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await appState.logout();
//               if (!context.mounted) return;
//               Navigator.of(context).pushReplacementNamed('/login');
//             },
//           ),
//         ],
//       ) : null,
//       body: Center(
//         child: widgetOptions[_selectedIndex],
//       ),
//       bottomNavigationBar: CurvedNavigationBar(
//         index: _selectedIndex,
//         height: 65,
//         items: <Widget>[
//           Icon(Icons.home,
//               size: 30,
//               color: appState.isDarkMode ? Colors.white : Colors.orange),
//           Icon(Icons.search_rounded,
//               size: 30,
//               color: appState.isDarkMode ? Colors.white : Colors.orange),
//           Icon(Icons.add_circle_outline_outlined,
//               size: 30,
//               color: appState.isDarkMode ? Colors.white : Colors.orange),
//           Icon(Icons.favorite,
//               size: 30,
//               color: appState.isDarkMode ? Colors.white : Colors.orange),
//           Icon(Icons.person_rounded,
//               size: 30,
//               color: appState.isDarkMode ? Colors.white : Colors.orange),
//         ],
//         color: appState.isDarkMode ? Colors.black : Colors.white,
//         buttonBackgroundColor:
//             appState.isDarkMode ? Colors.orange : Colors.orange[200],
//         backgroundColor: appState.isDarkMode ? Colors.black : Colors.white,
//         animationCurve: Curves.fastOutSlowIn,
//         animationDuration: const Duration(milliseconds: 600),
//         onTap: (index) {
//           if (index == 2) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => const AddEditRecipeScreen()),
//             );
//           } else {
//             setState(() {
//               _selectedIndex = index;
//             });
//           }
//         },
//       ),
//     );
//   }
// }