// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:get/get.dart';
// import 'controllers/auth_controller.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   Get.put(AuthController());
//   runApp(const MentalHealthApp());
// }

// class MentalHealthApp extends StatelessWidget {
//   const MentalHealthApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.teal,
//         useMaterial3: true,
//         colorSchemeSeed: Colors.teal,
//       ),
//       initialRoute: '/',
//       getPages: [
//         GetPage(name: '/', page: () => const AuthWrapper()),
//         GetPage(name: '/dashboard', page: () => const PredictionScreen()),
//         GetPage(name: '/auth', page: () => const LoginScreen()),
//       ],
//     );
//   }
// }

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final AuthController authController = Get.find();
//     return Obx(() {
//       return authController.isLoggedIn.value
//           ? const PredictionScreen()
//           : const LoginScreen();
//     });
//   }
// }

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authController = Get.find<AuthController>();
//     final emailController = TextEditingController();
//     final passwordController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: "Email"),
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: const InputDecoration(labelText: "Password"),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             Obx(
//               () => authController.isLoading.value
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: () => authController.login(
//                         emailController.text,
//                         passwordController.text,
//                       ),
//                       child: const Text("Login"),
//                     ),
//             ),
//             TextButton(
//               onPressed: () => Get.to(() => const SignupScreen()),
//               child: const Text("Don't have an account? Sign up"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PredictionScreen extends StatefulWidget {
//   const PredictionScreen({super.key});

//   @override
//   State<PredictionScreen> createState() => _PredictionScreenState();
// }

// class _PredictionScreenState extends State<PredictionScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _ageController = TextEditingController();
//   final AuthController _authController = Get.find();

//   String _stressLevel = 'Low';
//   String _sleepQuality = 'Good';
//   bool _isLoading = false;
//   String _result = "";

//   Future<void> getPrediction() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isLoading = true);

//     const String apiUrl = "http://10.0.2.2:8000/api/predict";

//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "uid": _authController.currentUser.value?.userId ?? "anonymous",
//           "age": int.parse(_ageController.text),
//           "stress_level": _stressLevel,
//           "sleep_quality": _sleepQuality,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() => _result = "Prediction: ${data['prediction']}");
//       } else {
//         setState(() => _result = "Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       setState(() => _result = "Server connection failed.");
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Predictor"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () => _authController.logout(),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               Text(
//                 "Welcome, ${_authController.currentUser.value?.userName ?? 'User'}",
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 controller: _ageController,
//                 decoration: const InputDecoration(
//                   labelText: "Age",
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) => value!.isEmpty ? "Enter age" : null,
//               ),
//               const SizedBox(height: 15),
//               DropdownButtonFormField(
//                 value: _stressLevel,
//                 decoration: const InputDecoration(
//                   labelText: "Stress Level",
//                   border: OutlineInputBorder(),
//                 ),
//                 items: ['Low', 'Medium', 'High']
//                     .map((l) => DropdownMenuItem(value: l, child: Text(l)))
//                     .toList(),
//                 onChanged: (value) => setState(() => _stressLevel = value!),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : getPrediction,
//                 child: _isLoading
//                     ? const CircularProgressIndicator()
//                     : const Text("Predict Status"),
//               ),
//               const SizedBox(height: 30),
//               Center(
//                 child: Text(
//                   _result,
//                   style: const TextStyle(fontSize: 18, color: Colors.teal),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SignupScreen extends StatelessWidget {
//   const SignupScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authController = Get.find<AuthController>();
//     final nameController = TextEditingController();
//     final emailController = TextEditingController();
//     final passwordController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Sign Up")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: "Full Name"),
//             ),
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: "Email"),
//             ),
//             TextField(
//               controller: passwordController,
//               decoration: const InputDecoration(labelText: "Password"),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             Obx(
//               () => authController.isLoading.value
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: () => authController.signup(
//                         nameController.text,
//                         emailController.text,
//                         passwordController.text,
//                         "0000000000",
//                       ),
//                       child: const Text("Register"),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MindCare",
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/input': (context) => const InputScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade200, Colors.white],
            begin: Alignment.topCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.psychology, size: 100, color: Colors.teal),
            Text(
              "MindCare",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade900,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "AI-Powered Mental Health Insights",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/input'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Start Assessment"),
            ),
          ],
        ),
      ),
    );
  }
}

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final ageController = TextEditingController();

  String stressLevel = 'Low';
  String sleepQuality = 'Good';
  bool isLoading = false;
  String result = "";

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }

  Future<void> getPrediction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    const url = "http://10.0.2.2:8000/api/predict";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "uid": "test_user",
          "age": int.parse(ageController.text),
          "stress_level": stressLevel,
          "sleep_quality": sleepQuality,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => result = "Prediction: ${data['prediction']}");
      } else {
        setState(() => result = "Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => result = "Server connection failed");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assessment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Age",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter age" : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                value: stressLevel,
                decoration: const InputDecoration(
                  labelText: "Stress Level",
                  border: OutlineInputBorder(),
                ),
                items: ['Low', 'Medium', 'High']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => stressLevel = v!),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField(
                value: sleepQuality,
                decoration: const InputDecoration(
                  labelText: "Sleep Quality",
                  border: OutlineInputBorder(),
                ),
                items: ['Good', 'Average', 'Poor']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => sleepQuality = v!),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLoading ? null : getPrediction,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Predict"),
              ),
              const SizedBox(height: 20),
              Center(child: Text(result, style: const TextStyle(fontSize: 18))),
            ],
          ),
        ),
      ),
    );
  }
}
