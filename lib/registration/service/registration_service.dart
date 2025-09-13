
import 'dart:convert';

import 'package:noviindus/auth/service/loginservice.dart';
import 'package:noviindus/constants.dart';
import 'package:noviindus/registration/models/branch_model.dart';
import 'package:noviindus/registration/models/treatment_model.dart';
import 'package:http/http.dart' as http;
class registrationService {


 final AuthService _authService = AuthService();





  Future<List<Treatment>> getTreatments() async {
    final url =  Uri.parse("${AppConstants.BaseUrl}${AppConstants.Treatments}");
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = TreatmentModel.fromJson(jsonDecode(response.body));
        return data.treatments ?? [];
      } else {
        throw Exception('Failed to load treatments: ${response.statusCode}');
      }
    } catch (e) {
  
      throw Exception('Failed to load treatments: $e');
    }
  }








  


 Future<List<Branches>> getBranch() async {
    final url = Uri.parse("${AppConstants.BaseUrl}${AppConstants.Branch}");
    try {
         final token = await _authService.getToken();
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseBody =  BranchModel.fromJson(jsonDecode(response.body));
         

         List<Branches> branches = responseBody.branches ?? [];
         
        return branches;
     
      } else {
        throw Exception('Failed to load branches: ${response.statusCode}');
      }
    } catch (e) {
      rethrow; 
    }
  }
}
