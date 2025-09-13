import 'package:flutter/material.dart';
import 'package:noviindus/auth/providers/auth_provider.dart';
import 'package:noviindus/auth/screens/login.dart';
import 'package:noviindus/patient/provider/patient_provider.dart';
import 'package:noviindus/registration/provider/registration_provider.dart';
import 'package:noviindus/splash/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),

        ChangeNotifierProvider<PatientProvider>(
          create: (_) => PatientProvider(),
        ),
        ChangeNotifierProvider<registrationProvider>(
          create: (_) => registrationProvider(),
        ),
      ],

      child: MaterialApp(home: Splash()),
    );
  }
}
