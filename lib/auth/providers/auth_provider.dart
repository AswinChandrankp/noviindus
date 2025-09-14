import 'package:flutter/material.dart';
import 'package:noviindus/auth/model/login_model.dart';
import 'package:noviindus/auth/service/auth_service.dart';
import 'package:noviindus/patient/screens/patient_screen.dart';
import 'package:noviindus/widgets/customSnackbar.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false; 
  bool get isLoading => _isLoading;

  String? _token;
  String? get token => _token;

  Future<void> getToken() async {
    _token = await _authService.getToken();
    notifyListeners();
  }

  Future<void> login(BuildContext context, String username, String password) async {
    _isLoading = true;
     notifyListeners();
    final loginModel? response = await _authService.login(username, password);
    if (response!.status!) {
      _token = response.token;
      print("login succefully");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PatientScreen()));
      _isLoading = false;
      notifyListeners();
    } else {
      CustomSnackbar.show(context: context, message: response.message.toString(), isSucces: false);
    }
   _isLoading = false;
    notifyListeners();
 
  }

  Future<void> logout() async {
    _token = null;
    await _authService.removeToken();
    notifyListeners();
  }
}