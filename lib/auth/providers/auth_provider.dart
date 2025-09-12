import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:noviindus/auth/model/login_model.dart';
import 'package:noviindus/auth/service/loginservice.dart';
import 'package:noviindus/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// class AuthProvider extends ChangeNotifier {
//   String? _token;
//   String? get token => _token;



//   Future<void> loadToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('token');      
//     notifyListeners();
//   }

//   Future<LoginModel> login(String username, String password) async {
//     try {
//       var request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BaseUrl}${AppConstants.login}'));
//       request.fields['username'] = username;
//       request.fields['password'] = password;
//       final response = await request.send();
//       if (response.statusCode == 200) {
//         final responseBody = LoginModel.fromJson(response.body);
//         final jsonData = json.decode(responseBody);
//         _token = jsonData['token']; 

//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('token', _token!);
//         notifyListeners();
//         return true;
//       } else {
//         return false;
//       }
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<void> logout() async {
//     _token = null;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//     notifyListeners();
//   }
// }








import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// class AuthProvider extends ChangeNotifier {
//   String? _token;
//   String? get token => _token;

//   Future<void> loadToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('token');
//     notifyListeners();
//   }

//   Future<LoginModel?> login(String username, String password) async {
//     try {
//       var request = http.MultipartRequest(
//           'POST', Uri.parse('${AppConstants.BaseUrl}${AppConstants.login}'));
//       request.fields['username'] = username;
//       request.fields['password'] = password;

//       final streamedResponse = await request.send();

//       if (streamedResponse.statusCode == 200) {
//         final responseString = await streamedResponse.stream.bytesToString();
//         final Map<String, dynamic> jsonData = json.decode(responseString);

//         final loginModel = LoginModel.fromJson(jsonData);

//         _token = loginModel.token;

//         final prefs = await SharedPreferences.getInstance();
//         if (_token != null) {
//           await prefs.setString('token', _token!);
//         }

//         notifyListeners();

//         return loginModel;
//       } else {
  
//         return null;
//       }
//     } catch (e) {
//       // Handle exceptions, maybe log them
//       return null;
//     }
//   }

//   Future<void> logout() async {
//     _token = null;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//     notifyListeners();
//   }
// }







import 'package:flutter/material.dart';


class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String? _token;
  String? get token => _token;

  Future<void> loadToken() async {
    _token = await _authService.loadToken();
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