// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/app_state.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   LoginScreenState createState() => LoginScreenState();
// }

// class LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your email';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your password';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     final success = await context.read<AppState>().login(
//                           _emailController.text,
//                           _passwordController.text,
//                         );
//                     if (success && mounted) {
//                       Navigator.pushReplacementNamed(context, '/main');
//                     } else if (mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Invalid email or password'),
//                         ),
//                       );
//                     }
//                   }
//                 },
//                 child: const Text('Login'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/register');
//                 },
//                 child: const Text('Create Account'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }