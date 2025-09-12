import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:noviindus/auth/model/login_model.dart';
import 'package:noviindus/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class loginService {
//   final SharedPreferences sharedPreferences;

//   loginService({required this.sharedPreferences});
//   Future<LoginModel> login(String username, String password) async {
//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('${AppConstants.BaseUrl}${AppConstants.login}'),
//       );
//       request.fields['username'] = username;
//       request.fields['password'] = password;

//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final user = LoginModel.fromJson(data);
//         await sharedPreferences.setString('token', user.token.toString());
//         print('Login successful with token: ${user.token}');
//         return user;
//       } else {
//         print('Login Error: ${response.statusCode} - ${response.body}');
//         throw Exception('Login failed: ${response.reasonPhrase}');
//       }
//     } catch (e) {
//       print('Login Network Error: $e');
//       throw Exception('Network error during login: $e');
//     }
//   }

 
// }








import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  static const String _tokenKey = 'token';

  Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<loginModel?> login(String username, String password) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConstants.BaseUrl}${AppConstants.login}'),
      );
      request.fields['username'] = username;
      request.fields['password'] = password;

      final streamedResponse = await request.send();

      if (streamedResponse.statusCode == 200) {
        final responseString = await streamedResponse.stream.bytesToString();
        final Map<String, dynamic> jsonData = json.decode(responseString);

        final loginModel data = loginModel.fromJson(jsonData);

        if (data.token != null) {
          await saveToken(data.token!);
        }

        return data;
      } else {
        return null;
      }
    } catch (e) {
      // Optionally log the error
      return null;
    }
  }
}