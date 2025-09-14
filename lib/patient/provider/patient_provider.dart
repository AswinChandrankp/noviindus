
import 'package:noviindus/patient/model/patient_model.dart';
import 'package:noviindus/patient/serviece/patient_service.dart';
import 'package:flutter/foundation.dart';




class PatientProvider with ChangeNotifier {
  final _patientService = PatientService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  

  List<Patient> _patients = [];
  List<Patient> get patients => _patients;

  PatientProvider() {
    getPatients(); 
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