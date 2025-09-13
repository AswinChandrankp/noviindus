import 'dart:convert';
import 'package:noviindus/auth/providers/auth_provider.dart';
import 'package:noviindus/patient/model/patient_model.dart';
import 'package:noviindus/patient/serviece/patient_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';





// class PatientProvider with ChangeNotifier {
//   final _patientService = PatientService ();

//   bool get isLoading => _isLoading;
//   bool _isLoading = false;
//   // final itemlenth = 0;
//   List<Patientmodel> _patients = [];
//   List<Patientmodel> get patients => _patients;



//   Future<void> getPatients() async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final patients = await _patientService.getPatiens();
//       print(patients);
//       _patients = patients;
//       print("Success");
//     } catch (e) {
//       print("Error while fetching patients: $e");
//       _patients = [];
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

 
// }



import 'package:flutter/foundation.dart';

class PatientProvider with ChangeNotifier {
  final _patientService = PatientService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  

  List<Patient> _patients = [];
  List<Patient> get patients => _patients;

  PatientProvider() {
    getPatients(); // Fetch patients on initialization
  }

  Future<void> getPatients() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<Patient> patients = await _patientService.getPatients();
      print(patients);
      
      _patients = patients;
      print("Success");
    } catch (e) {
      print("Error while fetching patients: $e");
      _patients = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



}