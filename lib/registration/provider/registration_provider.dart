import 'package:flutter/widgets.dart';
import 'package:noviindus/registration/models/branch_model.dart';
import 'package:noviindus/registration/models/treatment_model.dart';
import 'package:noviindus/registration/service/registration_service.dart';

class registrationProvider with ChangeNotifier {

 final _treatmentService = registrationService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

 List<Treatment> _treatments = [];
 List<Treatment> get treatments => _treatments;

 List <Branches> _branches = [];
 List<Branches> get branches => _branches;

 int _maleCount = 0;
 int get maleCount => _maleCount;

  int _FemaleCount = 0;
 int get FemaleCount => _FemaleCount;

 String treatmentname  = '';
 String get treatmentName => treatmentname;

  String? _selectedBranch;
  String? get selectedBranch => _selectedBranch;


      List<Map<String, String>> addtreatment = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _executiveController = TextEditingController();
  final TextEditingController _paymentController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _discountAmountController = TextEditingController();
  final TextEditingController _advanceAmountController = TextEditingController();
  final TextEditingController _balanceAmountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();


  TextEditingController get nameController => _nameController;
  TextEditingController get executiveController => _executiveController;
  TextEditingController get paymentController => _paymentController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get addressController => _addressController;
  TextEditingController get totalAmountController => _totalAmountController;
  TextEditingController get discountAmountController => _discountAmountController;
  TextEditingController get advanceAmountController => _advanceAmountController;
  TextEditingController get balanceAmountController => _balanceAmountController;
  TextEditingController get dateController => _dateController;
  TextEditingController get timeController => _timeController;

  registrationProvider(){
  getTreatments();
  getBranch();
  getTreatments();
}

  Future<void> getTreatments() async {
    _isLoading = true;
     _treatments = await _treatmentService.getTreatments();
    _isLoading = false;
    notifyListeners();
  }


  Future<void> getBranch() async {
    _isLoading = true;
     _branches = await _treatmentService.getBranch();
    _isLoading = false;
    notifyListeners();
  }

  void setBranch(String selectedbranch) {
    _selectedBranch = selectedbranch;
    notifyListeners();
  }
 

  



  void removeTreatment(int index) {
    treatments.removeAt(index);
    notifyListeners(); 
  }

   void addTreatment() {
   addtreatment.add({
      'treatment': treatmentname,
      'male': _maleCount.toString(),
      'female': _FemaleCount.toString(),
    });
    notifyListeners();

    clear();

  }

void maleIncrement() {
    _maleCount++;
    notifyListeners();
  }

  void maleDecrement() {
    if (_maleCount > 0) _maleCount  --;
    notifyListeners();
  }

  void femaleIncrement() {
    _FemaleCount ++;
    notifyListeners();
  }

  void femaleDecrement() {
    if (_FemaleCount > 0) _FemaleCount --;
    notifyListeners();
  }

  clear () {

    _maleCount = 0;
    _FemaleCount = 0;
    notifyListeners();
  }
}