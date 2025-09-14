import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:noviindus/auth/model/login_model.dart';
import 'package:noviindus/constants.dart';
import 'package:noviindus/widgets/customSnackbar.dart';
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
 

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }
 
  Future<void> saveToken(String token, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, token);
    await prefs.setString(AppConstants.userKey, username);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
  }

  Future<loginModel?> login(  String username, String password) async {
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
          await saveToken(data.token!,data.userDetails!.username.toString());
        }

        return data;
      } else {
        return null;
      }
    } catch (e) {
      if (e is http.ClientException) {
      throw Exception('Network error during login: ${e.message}');
    }
      return null;
    }
  }
}