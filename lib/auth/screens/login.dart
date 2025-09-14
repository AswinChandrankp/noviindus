
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noviindus/auth/providers/auth_provider.dart';

import 'package:noviindus/widgets/customButton.dart';
import 'package:noviindus/widgets/customSnackbar.dart';
import 'package:noviindus/widgets/customtextfield.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernamecontroller.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer <AuthProvider>(
      builder: (context, authProvider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset('assets/images/image.png', fit: BoxFit.cover),
          
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.1),
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                      // Centered logo
                      Center(
                        child: SvgPicture.asset(
                          'assets/images/logo.svg',
                          height: 80,
                          width: 80,
                        ),
                      ),
                    ],
                  ),
                ),
          
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Login Or Register To Book Your Appointments",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                            height: 1.3,
                          ),
                        ),
          
                        SizedBox(height: 32),
          
                        CustomTextField(
                          title: "Email",
                          controller: _usernamecontroller,
                          keyboardType: TextInputType.emailAddress,
                          hintText: "Enter your email",
                          isRequired: false,
                          borderColor: Color.fromRGBO(217, 217, 217, 0.25),
                          focusedBorderColor: Color.fromRGBO(217, 217, 217, 0.25),
                          errorBorderColor: Color.fromRGBO(217, 217, 217, 0.25),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
          
                        SizedBox(height: 24),
          
                        CustomTextField(
                          title: "Password",
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          hintText: "Enter Password",
                          isRequired: false,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
          
                        SizedBox(height: 100),
          
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              final email = _usernamecontroller.text.trim();
                              final password = _passwordController.text.trim();
                              if (email.isEmpty) {
                                CustomSnackbar.show(
                                  context: context,
                                  message: 'Please enter email',
                                  isSucces: false,
                                );
                              }
          
                              if (password.isEmpty) {
                                CustomSnackbar.show(
                                  context: context,
                                  message: 'Please enter password',
                                  isSucces: false,
                                );
                              }
                              if (email.isNotEmpty && password.isNotEmpty) {
                                Provider.of<AuthProvider>(
                                  context,
                                  listen: false,
                                ).login( context, email, password,);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                0,
                                104,
                                55,
                              ),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: authProvider.isLoading == true ? CircularProgressIndicator(color: Colors.white,) : Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
          
                        SizedBox(height: 100),
          
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6C757D),
                                  height: 1.4,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        "By creating or logging into an account you are agreeing with our ",
                                  ),
                                  TextSpan(
                                    text: "Terms and Conditions",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: " and "),
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: "."),
                                ],
                              ),
                            ),
                          ),
                        ),
          
                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
