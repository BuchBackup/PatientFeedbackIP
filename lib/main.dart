// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:new_bih_feedback/views/admitted_patient_view.dart';
// import 'package:new_bih_feedback/views/home_view.dart';
// import 'package:new_bih_feedback/views/login_view.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SplashScreen(),
//     );
//   }
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }

//   Future<void> _checkLoginStatus() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool? isLoggedIn = prefs.getBool('isLoggedIn');
//     if (isLoggedIn == true) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const AdmittedPatientView()),
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginView()),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:new_bih_feedback/views/admitted_patient_view.dart';
import 'package:new_bih_feedback/views/login_view.dart';

////App Create in Flutter 3.16
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstRun();
  }

  /// Check if the app is being run for the first time
  Future<void> _checkFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstRun = prefs.getBool('isFirstRun');

    // If first run, clear all stored preferences
    if (isFirstRun == null || isFirstRun == true) {
      await prefs.clear(); // Clear any stored data
      await prefs.setBool('isFirstRun', false); // Mark as not first run
    }

    _checkLoginStatus();
  }

  /// Check login status
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');

    if (isLoggedIn == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdmittedPatientView()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

// class LoginView extends StatelessWidget {
//   const LoginView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             await prefs.setBool('isLoggedIn', true); // Set login status
//             Get.off(() => const AdmittedPatientView()); // Navigate to home
//           },
//           child: const Text('Login'),
//         ),
//       ),
//     );
//   }
// }

// class AdmittedPatientView extends StatelessWidget {
//   const AdmittedPatientView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               SharedPreferences prefs = await SharedPreferences.getInstance();
//               await prefs.remove('isLoggedIn'); // Remove login status
//               Get.off(() => const LoginView()); // Navigate to login
//             },
//           )
//         ],
//       ),
//       body: const Center(child: Text('Welcome to Admitted Patient View!')),
//     );
//   }
// }
