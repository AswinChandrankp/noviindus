import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:noviindus/constants.dart';
import 'package:noviindus/registration/models/branch_model.dart';
import 'package:noviindus/registration/models/treatment_model.dart';
import 'package:noviindus/registration/screens/pdfscreen.dart';
import 'package:noviindus/registration/service/registration_service.dart';
import 'package:noviindus/widgets/customSnackbar.dart';
import 'package:noviindus/widgets/responsemodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class RegistrationProvider with ChangeNotifier {
  final _treatmentService = registrationService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Treatment> _treatments = [];
  List<Treatment> get treatments => _treatments;

  List<Branches> _branches = [];
  List<Branches> get branches => _branches;

  int _maleCount = 0;
  int get maleCount => _maleCount;

  int _femaleCount = 0;
  int get femaleCount => _femaleCount;

  Treatment? _selectedTreatment;
  Treatment? get selectedTreatment => _selectedTreatment;

  Branches? _selectedBranch;
  Branches? get selectedBranch => _selectedBranch;
  
  String? _selectedadress;
  String? get selectedadress => _selectedadress;

  String? _selectedTreatmentIds;
  String? get selectedTreatmentIds => _selectedTreatmentIds;

  String? _allMaleCount;
  String? get allMaleCount => _allMaleCount;

  String? _allFemaleCount;
  String? get allFemaleCount => _allFemaleCount;

  String? _userName;
  String? get userName => _userName;

  List<Map<String, dynamic>> addTreatment = [];
   List<String> alladress = ["Kozhikode","Palakkad","Thrissur","Kannur"];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _executiveController = TextEditingController();
  final TextEditingController _paymentController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  // final TextEditingController _addressController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _discountAmountController =
      TextEditingController();
  final TextEditingController _advanceAmountController =
      TextEditingController();
  final TextEditingController _balanceAmountController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  TextEditingController get nameController => _nameController;
  TextEditingController get executiveController => _executiveController;
  TextEditingController get paymentController => _paymentController;
  TextEditingController get phoneController => _phoneController;
  // TextEditingController get addressController => _addressController;
  TextEditingController get totalAmountController => _totalAmountController;
  TextEditingController get discountAmountController =>
      _discountAmountController;
  TextEditingController get advanceAmountController => _advanceAmountController;
  TextEditingController get balanceAmountController => _balanceAmountController;
  TextEditingController get dateController => _dateController;
  TextEditingController get timeController => _timeController;
  TextEditingController get detailsController => _detailsController;

  RegistrationProvider() {
    getTreatments();
    getBranch();
  }

  void getUser() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString(AppConstants.userKey);
  }

  String? validateFields() {
    if (_nameController.text.isEmpty) {
      return "Name is required.";
    }
    if (_phoneController.text.isEmpty) {
      return "Please enter a valid phone number.";
    }
    if (_selectedadress!.isEmpty) {
      return "Select a Location";
    }

    if (_selectedBranch == null) {
      return "Select a Branch.";
    }
    if (addTreatment.isEmpty) {
      return "Please add at least one treatment.";
    }
    if (_totalAmountController.text.isEmpty ||
        double.tryParse(_totalAmountController.text) == null) {
      return "Total amount must be a valid number.";
    }
    if (_discountAmountController.text.isEmpty ||
        double.tryParse(_discountAmountController.text) == null) {
      return "Discount amount must be a valid number.";
    }
    if (_advanceAmountController.text.isEmpty ||
        double.tryParse(_advanceAmountController.text) == null) {
      return "Advance amount must be a valid number.";
    }
    if (_balanceAmountController.text.isEmpty ||
        double.tryParse(_balanceAmountController.text) == null) {
      return "Balance amount must be a valid number.";
    }
    if (_selectedBranch == null) {
      return "Please select a branch.";
    }
    if (_selectedTreatment == null) {
      return "Please select a treatment.";
    }
    if (_allMaleCount == null && _allFemaleCount == null) {
      return "At least one male or female count should be provided.";
    }

    if (_dateController.text.isEmpty) {
      return "Please select a date.";
    }
    if (_timeController.text.isEmpty) {
      return "Please select a time.";
    }
    return null;
  }

  Future<void> register(BuildContext context) async {
    await getTreatmentIds();
    final validationMessage = validateFields();

    if (validationMessage != null) {
    CustomSnackbar.show(context: context, message: validationMessage,isSucces: false);;
      print(validationMessage);
      return;
    }

    // _isLoading = true;
    ResponseModel response = await _treatmentService.register(
      name: _nameController.text,
      excecutive: _userName ?? '',
      payment: _paymentController.text,
      phone: _phoneController.text,
      address: _selectedadress ?? '',
      totalAmount: _totalAmountController.text,
      discountAmount: _discountAmountController.text,
      advanceAmount: _advanceAmountController.text,
      balanceAmount: _balanceAmountController.text,
      dateNdTime: "${dateController.text + timeController.text}",
      male: _allMaleCount ?? '0',
      female: _allFemaleCount ?? '0',
      branch: _selectedBranch?.id.toString() ?? '',
      treatments: _selectedTreatmentIds ?? '',
      detail: _detailsController.text,
    );

    if (response.success) {
      CustomSnackbar.show(context: context, message: response.message,isSucces: true);
      // clearAllData();
       try {
    final filePath = await generateInvoicePDF();
    
 Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => InvoiceViewerPage(filePath: filePath),
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invoice PDF saved at: $filePath')),
    );
  } catch (e) {
    print('Error generating PDF: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to generate PDF: $e')),
    );
  }
    } else {
      // _isLoading = false;
     CustomSnackbar.show(context: context, message: response.message,isSucces: false);
    }
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

  void setBranch(Branches selectedBranch) {
    _selectedBranch = selectedBranch;
    notifyListeners();
  }

  void setTreatment(Treatment selectedTreatment) {
    _selectedTreatment = selectedTreatment;
    notifyListeners();
  }

  void setAddress (String address) {
    // _addressC.text = address;
    _selectedadress = address;
    notifyListeners();
  }

  void addTreatmentToList() {
    addTreatment.add({
      "name": _selectedTreatment?.name ?? '',
      'treatmentid': _selectedTreatment?.id.toString() ?? '',
      'male': _maleCount.toString(),
      'female': _femaleCount.toString(),
    });
    notifyListeners();
    clearCounts();
  }

  void incrementMaleCount() {
    _maleCount++;
    notifyListeners();
  }

  void deleteTreatment(int index) {
    addTreatment.removeAt(index);
    notifyListeners();
  }

  void decrementMaleCount() {
    if (_maleCount > 0) _maleCount--;
    notifyListeners();
  }

  void incrementFemaleCount() {
    _femaleCount++;
    notifyListeners();
  }

  void decrementFemaleCount() {
    if (_femaleCount > 0) _femaleCount--;
    notifyListeners();
  }

  void clearCounts() {
    _maleCount = 0;
    _femaleCount = 0;
    notifyListeners();
  }

  void clearAllData() {
    _selectedadress = null;
    _executiveController.clear();
    _nameController.clear();
    _phoneController.clear();
    _paymentController.clear();
    _totalAmountController.clear();
    _discountAmountController.clear();
    _advanceAmountController.clear();
    _balanceAmountController.clear();
    _dateController.clear();
    _timeController.clear();
    addTreatment.clear();
    _allMaleCount = null;
    _allFemaleCount = null;
    _selectedBranch = null;
    _selectedTreatment = null;
    _selectedTreatmentIds = null;

    notifyListeners();
  }

  getTreatmentIds() {
    List<int> maleTreatmentIds = [];
    List<int> femaleTreatmentIds = [];
    List<int> allTreatmentIds = [];

    for (var treatment in addTreatment) {
      maleTreatmentIds.add(int.parse(treatment['male']));
      femaleTreatmentIds.add(int.parse(treatment['female']));
      allTreatmentIds.add(int.parse(treatment['treatmentid']));
    }

    _allMaleCount = maleTreatmentIds.join(',');
    _allFemaleCount = femaleTreatmentIds.join(',');
    _selectedTreatmentIds = allTreatmentIds.join(',');
  }


















Future<String> generateInvoicePDF() async {
    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    final graphics = page.graphics;

    final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);
    final PdfFont regularFont = PdfStandardFont(PdfFontFamily.helvetica, 12);

    graphics.drawString(
      'Invoice for ${_nameController.text}',
      titleFont,
      bounds: Rect.fromLTWH(40, 50, pageSize.width - 80, 25),
    );

    graphics.drawString(
      'Phone: ${_phoneController.text}',
      regularFont,
      bounds: Rect.fromLTWH(40, 90, pageSize.width - 80, 20),
    );

    graphics.drawString(
      'Address: ${_selectedadress ?? '-'}',
      regularFont,
      bounds: Rect.fromLTWH(40, 115, pageSize.width - 80, 20),
    );

    graphics.drawString(
      'Branch: ${_selectedBranch?.name ?? '-'}',
      regularFont,
      bounds: Rect.fromLTWH(40, 140, pageSize.width - 80, 20),
    );

    double y = 170;

    graphics.drawString(
      'Treatments:',
      titleFont,
      bounds: Rect.fromLTWH(40, y, pageSize.width - 80, 20),
    );

    y += 30;

    for (var treatment in addTreatment) {
      graphics.drawString(
        '${treatment['name']} (Males: ${treatment['male']}, Females: ${treatment['female']})',
        regularFont,
        bounds: Rect.fromLTWH(40, y, pageSize.width - 80, 20),
      );
      y += 25;
    }

    y += 10;
    graphics.drawString(
      'Total Amount: ₹${_totalAmountController.text}',
      titleFont,
      bounds: Rect.fromLTWH(40, y + 20, pageSize.width - 80, 25),
    );

    // Save PDF bytes
    final bytes = await document.save();
    document.dispose();

    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }



}
