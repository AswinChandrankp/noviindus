
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noviindus/auth/service/auth_service.dart';
import 'package:noviindus/constants.dart';
import 'package:noviindus/registration/models/branch_model.dart';
import 'package:noviindus/registration/models/treatment_model.dart';
import 'package:http/http.dart' as http;
import 'package:noviindus/widgets/responsemodel.dart';
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

 
Future<ResponseModel> register({
  required String name,
  required String excecutive,
  required String payment,
  required String phone,
  required String address,
  required String totalAmount,
  required String discountAmount,
  required String advanceAmount,
  required String balanceAmount,
  required String dateNdTime,
  required String male,
  required String female,
  required String branch,
  required String treatments,
  required String detail,

}) async {
  try {
    // Get the token for authentication
    final token = await _authService.getToken();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.BaseUrl}${AppConstants.Registration}'),
    );

    // Set the Authorization header
    request.headers['Authorization'] = 'Bearer $token';

    // Add form fields to the request
    request.fields['name'] = name;
    request.fields['excecutive'] = excecutive;
    request.fields['payment'] = payment;
    request.fields['phone'] = phone;
    request.fields['address'] = address;
    request.fields['total_amount'] = totalAmount;
    request.fields['discount_amount'] = discountAmount;
    request.fields['advance_amount'] = advanceAmount;
    request.fields['balance_amount'] = balanceAmount;
    request.fields['date_nd_time'] = dateNdTime;
    request.fields["id"] = "";
    request.fields["male"] = male;
    request.fields["female"] = female;
    request.fields["branch"] = branch;
    request.fields["treatments"] = treatments;
    request.fields["detail"] = detail;  

    final  response = await request.send();

    final responseString = await response.stream.bytesToString();

    
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(responseString);
      return ResponseModel(
        success: true,
        message: "Registration successful",
        data: jsonData,  
      );
    } else {
      return ResponseModel(
        success: false,
        message: "Failed to register. Status Code: ${response.statusCode}",
      );
    }
  } catch (e) {
    return ResponseModel(
      success: false,
      message: "Error occurred: $e",
    );
  }
}

}
