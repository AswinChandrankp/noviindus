import 'dart:convert';

import 'package:noviindus/auth/service/loginservice.dart';
import 'package:noviindus/constants.dart';
import 'package:noviindus/patient/model/patient_model.dart';
import 'package:http/http.dart' as http;

class PatientService {

 final AuthService _authService = AuthService();


Future<List<Patient>> getPatients() async {
  final url = Uri.parse("${AppConstants.BaseUrl}${AppConstants.Patient}");
  final token = await _authService.getToken();
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer ${token}',
  });

  if (response.statusCode == 200) {
    final responseBody = jsonDecode(response.body);
    if (responseBody is Map<String, dynamic>) {
      final patientModel = Patientmodel.fromJson(responseBody);
      if (patientModel.patient != null && patientModel.patient!.isNotEmpty) {
        return patientModel.patient!;
      } else {
        return []; 
      }
    } else {
      throw Exception('API returned an unexpected response: ${response.body}');
    }
  } else {
    throw Exception('Failed to load patients: ${response.statusCode}');
  }
}
 








}
