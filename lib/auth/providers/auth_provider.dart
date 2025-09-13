import 'package:flutter/material.dart';
import 'package:noviindus/auth/service/loginservice.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String? _token;
  String? get token => _token;

  Future<void> getToken() async {
    _token = await _authService.getToken();
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    final loginModel = await _authService.login(username, password);
    if (loginModel != null) {
      _token = loginModel.token;
      notifyListeners();
    }
    // return data;
  }

  Future<void> logout() async {
    _token = null;
    await _authService.removeToken();
    notifyListeners();
  }
}