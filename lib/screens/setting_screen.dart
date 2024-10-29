// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/app_state.dart';
// import 'privacy_policy_screen.dart'; 

// class SettingScreen extends StatelessWidget {
//   const SettingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Settings'),
//       ),
//       body: Consumer<AppState>(
//         builder: (context, appState, child) {
//           return ListView(
//             children: [
//               ListTile(
//                 title: const Text('Dark Mode'),
//                 trailing: Switch(
//                   value: appState.isDarkMode,
//                   onChanged: (bool value) {
//                     appState.toggleDarkMode();
//                   },
//                 ),
//               ),
//               ListTile(
//                 title: const Text('Privacy Policy'),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const PrivacyPolicyScreen(),
//                     ),
//                   );
//                 },
//               ),
//               const ListTile(
//                 title: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('Version'),

//                     Text('1.0.0'), // version
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import 'privacy_policy_screen.dart';
import 'about_us_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return ListView(
            children: [
              ListTile(
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: appState.isDarkMode,
                  onChanged: (bool value) {
                    appState.toggleDarkMode();
                  },
                ),
              ),
              ListTile(
                title: const Text('Privacy Policy'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('About Us'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutUsScreen(),
                    ),
                  );
                },
              ),
              const ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Version'),
                    Text('1.0.0'), // version
                  ],
                ),
              ),
              ListTile(
                title: const Text('Logout'),
                trailing: const Icon(Icons.logout),
                onTap: () {
                  // Show a confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Logout'),
                            onPressed: () {
                              // Perform logout action
                              //appState.logout();
                              // Navigate to login screen
                              Navigator.of(context).pushReplacementNamed('/login');
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}