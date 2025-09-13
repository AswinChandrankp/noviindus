import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noviindus/auth/screens/login.dart';
import 'package:noviindus/patient/screens/patient_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class Splash extends StatefulWidget {
//   @override
//   _SplashState createState() => _SplashState();
// }

// class _SplashState extends State<Splash> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateToNextPage();
//   }

//   Future<void> _navigateToNextPage() async {

    
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userToken = prefs.getString('token');

//     print("Retrieved token in splash screen: $userToken");

//     await Future.delayed(Duration(seconds: 2));

//     if (!mounted) return;

//     if (userToken == null || userToken.isEmpty) {
//       print("No token found or token is invalid, navigating to login page.");
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     } else {
//       print("Token found and is valid, navigating to home page.");
//       // TODO: Replace PatientScreen() with your actual home screen widget
//       // Navigator.pushReplacement(
//       //   context,
//       //   MaterialPageRoute(builder: (context) => PatientScreen()),
//       // );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.asset(
//             'assets/images/iPhone 13 & 14 - 1.png', 
//             fit: BoxFit.cover,
//           ),
//           // Center(
//           //   child: SvgPicture.asset(
//           //     'assets/images/logo.svg',
//           //     width: 200,
//           //     height: 200,
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noviindus/auth/screens/login.dart';
import 'package:noviindus/auth/providers/auth_provider.dart';
// import your home screen here
// import 'package:noviindus/home/home_screen.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.getToken();

    // Wait for splash duration
    await Future.delayed(Duration(seconds: 2));

   

    if (authProvider.token == null || authProvider.token!.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => /* HomeScreen() */ PatientScreen()), // Replace with your home screen
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/iPhone 13 & 14 - 1.png',
            fit: BoxFit.cover,
          ),
          // Optional: add a loading indicator or logo here
          // Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}