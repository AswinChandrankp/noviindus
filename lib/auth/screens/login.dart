
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:noviindus/auth/providers/auth_provider.dart';

import 'package:noviindus/widgets/customButton.dart';
import 'package:noviindus/widgets/customtextfield.dart';
import 'package:provider/provider.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 217,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(
                    'assets/images/image.png',
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/logo.svg',
                      height: 84,
                      width: 80,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Login or register to book your appointments",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    title: "Email",
                    controller: _usernameController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: "Enter your Mail",
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
                  SizedBox(height: 20),
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
                  SizedBox(height: 20),
                  CustomElevatedButton(
                    text: "Login",
                    onPressed: () {
                      final username = _usernameController.text.trim();
                      final password = _passwordController.text.trim();
        
                      Provider.of<AuthProvider>(context, listen: false)
                          .login(username, password);
                      //     .then((loginModel) {
                      //   if (loginModel != null && loginModel.status == true) {
                      //     // Navigate to next screen on success
                      //     Navigator.pushReplacementNamed(context, '/home');
                      //   } else {
                      //     // Show error message or snackbar
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(content: Text(loginModel?.message ?? 'Login failed')),
                      //     );
                      //   }
                      // });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}