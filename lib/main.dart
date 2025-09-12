import 'package:flutter/material.dart';
import 'package:noviindus/auth/providers/auth_provider.dart';
import 'package:noviindus/auth/screens/login.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return 
    MultiProvider(

      providers: [

        ChangeNotifierProvider<AuthProvider>(

          create: (_) => AuthProvider(),

        ),

        // Add other providers here if needed

      ],

      child: MaterialApp(

        title: 'Flutter Auth Demo',

        theme: ThemeData(

          primarySwatch: Colors.blue,

        ),

        home: LoginScreen(),

      ),

    );
  
  }
}
