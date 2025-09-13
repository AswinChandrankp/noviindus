import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      'price': _selectedTreatment?.price.toString() ?? '',
      'treatmentid': _selectedTreatment?.id.toString() ?? '',
      'male': _maleCount.toString(),
      'female': _femaleCount.toString(),
      'total': (_maleCount + _femaleCount) * double.parse(_selectedTreatment?.price ?? '0'),
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
      print(treatment["price"]);
      print(treatment["total"]);
      maleTreatmentIds.add(int.parse(treatment['male']));
      femaleTreatmentIds.add(int.parse(treatment['female']));
      allTreatmentIds.add(int.parse(treatment['treatmentid']));
    }

    _allMaleCount = maleTreatmentIds.join(',');
    _allFemaleCount = femaleTreatmentIds.join(',');
    _selectedTreatmentIds = allTreatmentIds.join(',');
  }


















// Future<String> generateInvoicePDF() async {
//     final PdfDocument document = PdfDocument();
//     final PdfPage page = document.pages.add();
//     final Size pageSize = page.getClientSize();
//     final graphics = page.graphics;

//     final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);
//     final PdfFont regularFont = PdfStandardFont(PdfFontFamily.helvetica, 12);

//     graphics.drawString(
//       'Invoice for ${_nameController.text}',
//       titleFont,
//       bounds: Rect.fromLTWH(40, 50, pageSize.width - 80, 25),
//     );

//     graphics.drawString(
//       'Phone: ${_phoneController.text}',
//       regularFont,
//       bounds: Rect.fromLTWH(40, 90, pageSize.width - 80, 20),
//     );

//     graphics.drawString(
//       'Address: ${_selectedadress ?? '-'}',
//       regularFont,
//       bounds: Rect.fromLTWH(40, 115, pageSize.width - 80, 20),
//     );

//     graphics.drawString(
//       'Branch: ${_selectedBranch?.name ?? '-'}',
//       regularFont,
//       bounds: Rect.fromLTWH(40, 140, pageSize.width - 80, 20),
//     );

//     double y = 170;

//     graphics.drawString(
//       'Treatments:',
//       titleFont,
//       bounds: Rect.fromLTWH(40, y, pageSize.width - 80, 20),
//     );

//     y += 30;

//     for (var treatment in addTreatment) {
//       graphics.drawString(
//         '${treatment['name']} (Males: ${treatment['male']}, Females: ${treatment['female']})',
//         regularFont,
//         bounds: Rect.fromLTWH(40, y, pageSize.width - 80, 20),
//       );
//       y += 25;
//     }

//     y += 10;
//     graphics.drawString(
//       'Total Amount: ₹${_totalAmountController.text}',
//       titleFont,
//       bounds: Rect.fromLTWH(40, y + 20, pageSize.width - 80, 25),
//     );

//     // Save PDF bytes
//     final bytes = await document.save();
//     document.dispose();

//     // Save to file
//     final directory = await getApplicationDocumentsDirectory();
//     final filePath = '${directory.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
//     final file = File(filePath);
//     await file.writeAsBytes(bytes);

//     return filePath;
//   }


// Future<String> generateInvoicePDF() async {
//   final PdfDocument document = PdfDocument();
//   final PdfPage page = document.pages.add();
//   final Size pageSize = page.getClientSize();
//   final graphics = page.graphics;

//   // Fonts
//   final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);
//   final PdfFont sectionTitleFont = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
//   final PdfFont regularFont = PdfStandardFont(PdfFontFamily.helvetica, 12);

//   // Load logo image bytes once
//   final ByteData logoBytes = await rootBundle.load('assets/images/Asset.png');
//   final Uint8List logoList = logoBytes.buffer.asUint8List();
//   final PdfBitmap logo = PdfBitmap(logoList);

//   // ----------- HEADER SETUP -----------
//   const double headerHeight = 120;
//   final PdfPageTemplateElement header = PdfPageTemplateElement(Rect.fromLTWH(0, 0, pageSize.width, headerHeight));

//   // Header background color
//   header.graphics.drawRectangle(
//     // brush: PdfSolidBrush(PdfColor(245, 245, 245)),

//     bounds: Rect.fromLTWH(0, 0, pageSize.width, headerHeight),
//   );

//   // Logo left-aligned in header
//   const double logoWidth = 80;
//   const double logoHeight = 80;
//   const double logoMarginLeft = 40;
//   final double logoPosY = (headerHeight - logoHeight) / 2;

//   header.graphics.drawImage(logo, Rect.fromLTWH(logoMarginLeft, logoPosY, logoWidth, logoHeight));

//   // Header text next to logo
//   header.graphics.drawString(
//   'Cheepunkal P.O. Kumarakom, kottayam, Kerala - 686563\ne-mail: unknown@gmail.com\nMob: +91 9876543210 | +91 9786543210',
//   PdfStandardFont(PdfFontFamily.helvetica, 8, style: PdfFontStyle.regular,),
//   bounds: Rect.fromLTWH(
//     0,
//     logoPosY + 15,
//     pageSize.width - 40, 
//     logoHeight,
//   ),
//   brush:  PdfSolidBrush(
//     PdfColor(100, 128, 128),
//   ),
//   format: PdfStringFormat(
//     alignment: PdfTextAlignment.right,
//     lineAlignment: PdfVerticalAlignment.top,
//   ),
// );
//   header.graphics.drawString(
//   'KUMARAKOM',
//   PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.regular,),
//   bounds: Rect.fromLTWH(
//     0,
//     logoPosY,
//     pageSize.width - 40, 
//     logoHeight,
//   ),
//   brush:  PdfSolidBrush(
//   PdfColor(0, 0, 0)

//   ),
//   format: PdfStringFormat(
//     alignment: PdfTextAlignment.right,
//     lineAlignment: PdfVerticalAlignment.top,
//   ),
// );
//   header.graphics.drawString(
//   'GST No: 32AABCU9603R1ZW',
//   PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.regular,),
//   bounds: Rect.fromLTWH(
//     0,
//     logoPosY +50,
//     pageSize.width - 40, 
//     logoHeight,
//   ),
//   brush:  PdfSolidBrush(
//   PdfColor(0, 0, 0)

//   ),
//   format: PdfStringFormat(
//     alignment: PdfTextAlignment.right,
//     lineAlignment: PdfVerticalAlignment.top,
//   ),
// );
//   document.template.top = header;

// header.graphics.drawLine(
//   PdfPen(PdfColor(100, 128, 120), width:.5 ), 
//   Offset(40, headerHeight - 1),                // Start point (left, bottom of header)
//   Offset(pageSize.width - 40, headerHeight - 1),  // End point (right, bottom of header)
// );
//   // ----------- FOOTER SETUP -----------
//   const double footerHeight = 50;
//   final PdfPageTemplateElement footer = PdfPageTemplateElement(Rect.fromLTWH(0, 0, pageSize.width, footerHeight));

//   // Footer background color (optional)
//   footer.graphics.drawRectangle(
//     brush: PdfSolidBrush(PdfColor(230, 230, 250)),  // light lavender
//     bounds: Rect.fromLTWH(0, 0, pageSize.width, footerHeight),
//   );

//   // Footer text centered
//   footer.graphics.drawString(
//     'Thank you for your business!',
//     PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.italic),
//     bounds: Rect.fromLTWH(0, 15, pageSize.width, 20),
//     format: PdfStringFormat(alignment: PdfTextAlignment.center),
//   );

//   document.template.bottom = footer;

//   // ----------- BACKGROUND WATERMARK -----------
//   graphics.setTransparency(0.1);

//   const double watermarkWidth = 300;
//   const double watermarkHeight = 300;
//   final double watermarkX = (pageSize.width - watermarkWidth) / 2;
//   final double watermarkY = (pageSize.height - watermarkHeight) / 2;

//   graphics.drawImage(logo, Rect.fromLTWH(watermarkX, watermarkY, watermarkWidth, watermarkHeight));

//   graphics.setTransparency(1);

//   // ----------- MAIN CONTENT -----------
//   double y = headerHeight + 20;

// // Header for section
// graphics.drawString(
//   'Patient Details',
//   PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold),
//   bounds: Rect.fromLTWH(40, y, 150, 20),
//   brush: PdfSolidBrush(PdfColor(0, 180, 100)), // Green color (#00B464)
// );

// y += 25;

// // Left column labels and values
// final double labelX = 40;
// final double valueX = 110;
// final double columnY = y;
// final double rowHeight = 20;

// // Name row
// graphics.drawString(
//   'Name',
//   PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
//   bounds: Rect.fromLTWH(labelX, columnY, 60, rowHeight),
//   brush: PdfSolidBrush(PdfColor(0, 0, 0)),
// );
// graphics.drawString(
//   "${_nameController.text}",
//   PdfStandardFont(PdfFontFamily.helvetica, 12),
//   bounds: Rect.fromLTWH(valueX, columnY, 120, rowHeight),
//   brush: PdfSolidBrush(PdfColor(154, 154, 154)), // Gray (#9A9A9A)
// );

// // Address row
// graphics.drawString(
//   'Address',
//   PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
//   bounds: Rect.fromLTWH(labelX, columnY + rowHeight, 60, rowHeight),
//   brush: PdfSolidBrush(PdfColor(0, 0, 0)),
// );
// graphics.drawString(
//   "${_selectedadress} ",
//   PdfStandardFont(PdfFontFamily.helvetica, 12),
//   bounds: Rect.fromLTWH(valueX, columnY + rowHeight, 120, rowHeight),
//   brush: PdfSolidBrush(PdfColor(154, 154, 154)),
// );

// // WhatsApp row
// graphics.drawString(
//   'WhatsApp Number',
//   PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
//   bounds: Rect.fromLTWH(labelX, columnY + 2 * rowHeight, 90, rowHeight),
//   brush: PdfSolidBrush(PdfColor(0, 0, 0)),
// );
// graphics.drawString(
//   "${_phoneController.text}",
//   PdfStandardFont(PdfFontFamily.helvetica, 12),
//   bounds: Rect.fromLTWH(valueX, columnY + 2 * rowHeight, 120, rowHeight),
//   brush: PdfSolidBrush(PdfColor(154, 154, 154)),
// );

// // Right column positions
// final double rightLabelX = pageSize.width / 2 + 10;
// final double rightValueX = rightLabelX + 90;

// // Booked On
// graphics.drawString(
//   'Booked On',
//   PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
//   bounds: Rect.fromLTWH(rightLabelX, columnY, 80, rowHeight),
//   brush: PdfSolidBrush(PdfColor(0, 0, 0)),
// );
// graphics.drawString(
//   "bookedOnDate",
//   PdfStandardFont(PdfFontFamily.helvetica, 12),
//   bounds: Rect.fromLTWH(rightValueX, columnY, 70, rowHeight),
//   brush: PdfSolidBrush(PdfColor(154, 154, 154)),
// );
// // Time next to Booked On Date
// graphics.drawString(
//   "bookedOnTime",
//   PdfStandardFont(PdfFontFamily.helvetica, 12),
//   bounds: Rect.fromLTWH(rightValueX + 75, columnY, 50, rowHeight),
//   brush: PdfSolidBrush(PdfColor(154, 154, 154)),
// );

// // Treatment Date
// graphics.drawString(
//   'Treatment Date',
//   PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
//   bounds: Rect.fromLTWH(rightLabelX, columnY + rowHeight, 90, rowHeight),
//   brush: PdfSolidBrush(PdfColor(0, 0, 0)),
// );
// graphics.drawString(
//   "${_dateController.text}",
//   PdfStandardFont(PdfFontFamily.helvetica, 12),
//   bounds: Rect.fromLTWH(rightValueX, columnY + rowHeight, 70, rowHeight),
//   brush: PdfSolidBrush(PdfColor(154, 154, 154)),
// );

// // Treatment Time
// graphics.drawString(
//   'Treatment Time',
//   PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
//   bounds: Rect.fromLTWH(rightLabelX, columnY + 2 * rowHeight, 90, rowHeight),
//   brush: PdfSolidBrush(PdfColor(0, 0, 0)),
// );
// graphics.drawString(
//   "${_timeController.text}",
//   PdfStandardFont(PdfFontFamily.helvetica, 12),
//   bounds: Rect.fromLTWH(rightValueX, columnY + 2 * rowHeight, 70, rowHeight),
//   brush: PdfSolidBrush(PdfColor(154, 154, 154)),
// );
 
// y += 3 * rowHeight + 15; // Adjust y for next content







 
//   graphics.drawString(
//     'Treatments',
//     sectionTitleFont,
//     bounds: Rect.fromLTWH(40, y, pageSize.width - 80, 20),
//   );
//   y += 30;
// final PdfColor headerGreen = PdfColor(0, 149, 94);
// final PdfColor cellGray = PdfColor(154, 154, 154);
//   final PdfGrid grid = PdfGrid();
//   grid.columns.add(count:5);
//   grid.headers.add(1);

//   final PdfGridRow headerRow = grid.headers[0];
  
//   headerRow.cells[0].value = 'Treatment';
//    headerRow.cells[1].value = 'Price';
//   headerRow.cells[2].value = 'Males';
//   headerRow.cells[3].value = 'Females';
// headerRow.cells[4].value = 'total';
//   for (var treatment in addTreatment) {
//     final PdfGridRow row = grid.rows.add();
//     row.cells[0].value = treatment['name'];
//     row.cells[1].value = treatment['price'].toString();
//     row.cells[2].value = treatment['male'].toString();
//     row.cells[3].value = treatment['female'].toString();
//     row.cells[4].value = treatment['total'].toString();
//   }
//  for (var i = 0; i < 5; i++) {
//   headerRow.cells[i].style = PdfGridCellStyle(
//     font: PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
//     textBrush: PdfSolidBrush(headerGreen),
//     cellPadding: PdfPaddings(left: 5, right: 5, top: 6, bottom: 6),
//     borders: PdfBorders(), // No borders
//   );
// }

// for (var i = 0; i < 5; i++) {
//   headerRow.cells[i].style = PdfGridCellStyle(
//     font: PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
//     textBrush: PdfSolidBrush(headerGreen),
//     cellPadding: PdfPaddings(left: 5, right: 5, top: 6, bottom: 6),
//     borders: PdfBorders(), // No borders
//   );
// }

//   grid.style = PdfGridStyle(
//   cellPadding: PdfPaddings(left: 5, right: 5, top: 6, bottom: 6),
//   font: PdfStandardFont(PdfFontFamily.helvetica, 12),
//   // borderPen: PdfPens.transparent, // No outline/borders
//   borderOverlapStyle: PdfBorderOverlapStyle.inside,
// );
  
//   final PdfLayoutResult result = grid.draw(

//     page: page,
//     bounds: Rect.fromLTWH(40, y, pageSize.width -40, 0),
//   )!;

//   y = result.bounds.bottom + 30;

//   graphics.drawString(
//     'Total Amount: ₹${_totalAmountController.text}',
//     sectionTitleFont,
//     bounds: Rect.fromLTWH(40, y, pageSize.width - 80, 25),
//   );

//   // Save PDF bytes
//   final pdfBytes = await document.save();
//   document.dispose();

//   // Save to file
//   final directory = await getApplicationDocumentsDirectory();
//   final filePath = '${directory.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
//   final file = File(filePath);
//   await file.writeAsBytes(pdfBytes);

//   return filePath;
// }

Future<String> generateInvoicePDF() async {
  final PdfDocument document = PdfDocument();
  final PdfPage page = document.pages.add();
  final Size pageSize = page.getClientSize();
  final graphics = page.graphics;

  // Fonts
  final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);
  final PdfFont sectionTitleFont = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
  final PdfFont regularFont = PdfStandardFont(PdfFontFamily.helvetica, 12);

  // Load logo image bytes once
  final ByteData logoBytes = await rootBundle.load('assets/images/Asset.png');
  final ByteData sighnBytes = await rootBundle.load('assets/images/Vector 1.png');
  final Uint8List logoList = logoBytes.buffer.asUint8List();
  final Uint8List sighnList = sighnBytes.buffer.asUint8List();
  final PdfBitmap logo = PdfBitmap(logoList);
  final PdfBitmap sighn = PdfBitmap(sighnList);

  // ----------- HEADER SETUP -----------
  const double headerHeight = 120;
  final PdfPageTemplateElement header = PdfPageTemplateElement(Rect.fromLTWH(0, 0, pageSize.width, headerHeight));

  header.graphics.drawRectangle(
    bounds: Rect.fromLTWH(0, 0, pageSize.width, headerHeight),
  );

  // Logo left-aligned in header
  const double logoWidth = 80;
  const double logoHeight = 80;
  const double logoMarginLeft = 40;
  final double logoPosY = (headerHeight - logoHeight) / 2;

  header.graphics.drawImage(logo, Rect.fromLTWH(logoMarginLeft, logoPosY, logoWidth, logoHeight));

  // Header text next to logo, right-aligned
  header.graphics.drawString(
    'Cheepunkal P.O. Kumarakom, kottayam, Kerala - 686563\ne-mail: unknown@gmail.com\nMob: +91 9876543210 | +91 9786543210',
    PdfStandardFont(PdfFontFamily.helvetica, 8),
    bounds: Rect.fromLTWH(0, logoPosY + 15, pageSize.width - 40, logoHeight),
    brush: PdfSolidBrush(PdfColor(100, 128, 128)),
    format: PdfStringFormat(
      alignment: PdfTextAlignment.right,
      lineAlignment: PdfVerticalAlignment.top,
    ),
  );
  header.graphics.drawString(
    'KUMARAKOM',
    PdfStandardFont(PdfFontFamily.helvetica, 10),
    bounds: Rect.fromLTWH(0, logoPosY, pageSize.width - 40, logoHeight),
    brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    format: PdfStringFormat(
      alignment: PdfTextAlignment.right,
      lineAlignment: PdfVerticalAlignment.top,
    ),
  );
  header.graphics.drawString(
    'GST No: 32AABCU9603R1ZW',
    PdfStandardFont(PdfFontFamily.helvetica, 10),
    bounds: Rect.fromLTWH(0, logoPosY + 50, pageSize.width - 40, logoHeight),
    brush: PdfSolidBrush(PdfColor(0, 0, 0)),
    format: PdfStringFormat(
      alignment: PdfTextAlignment.right,
      lineAlignment: PdfVerticalAlignment.top,
    ),
  );
  document.template.top = header;

  // Divider line at the bottom of the header
  header.graphics.drawLine(
    PdfPen(PdfColor(100, 128, 120), width: .5),
    Offset(40, headerHeight - 1),
    Offset(pageSize.width - 40, headerHeight - 1),
  );

  // ----------- FOOTER SETUP -----------
  const double footerHeight = 50;
  final PdfPageTemplateElement footer = PdfPageTemplateElement(Rect.fromLTWH(0, 0, pageSize.width, footerHeight));

  footer.graphics.drawRectangle(
    brush: PdfSolidBrush(PdfColor(230, 230, 250)),
    bounds: Rect.fromLTWH(0, 0, pageSize.width, footerHeight),
  );

  footer.graphics.drawString(
    'Thank you for your business!',
    PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.italic),
    bounds: Rect.fromLTWH(0, 15, pageSize.width, 20),
    format: PdfStringFormat(alignment: PdfTextAlignment.center),
  );

  document.template.bottom = footer;

  // ----------- BACKGROUND WATERMARK -----------
  graphics.setTransparency(0.1);
  const double watermarkWidth = 300;
  const double watermarkHeight = 300;
  final double watermarkX = (pageSize.width - watermarkWidth) / 2;
  final double watermarkY = (pageSize.height - watermarkHeight) / 2;

  graphics.drawImage(logo, Rect.fromLTWH(watermarkX, watermarkY, watermarkWidth, watermarkHeight));
  graphics.setTransparency(1);

  // ----------- MAIN CONTENT -----------
  double y = headerHeight + 20;

  // Patient Details Title
  graphics.drawString(
    'Patient Details',
    PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold),
    bounds: Rect.fromLTWH(40, y, 150, 20),
    brush: PdfSolidBrush(PdfColor(0, 180, 100)),
  );
  y += 25;

  // Patient Info (two columns)
  final double labelX = 40;
  final double valueX = 110;
  final double columnY = y;
  final double rowHeight = 20;

  graphics.drawString('Name', PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
    bounds: Rect.fromLTWH(labelX, columnY, 60, rowHeight), brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  graphics.drawString("${_nameController.text}", PdfStandardFont(PdfFontFamily.helvetica, 12),
    bounds: Rect.fromLTWH(valueX, columnY, 120, rowHeight), brush: PdfSolidBrush(PdfColor(154, 154, 154)));

  graphics.drawString('Address', PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
    bounds: Rect.fromLTWH(labelX, columnY + rowHeight, 60, rowHeight), brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  graphics.drawString("${_selectedadress} ", PdfStandardFont(PdfFontFamily.helvetica, 12),
    bounds: Rect.fromLTWH(valueX, columnY + rowHeight, 120, rowHeight), brush: PdfSolidBrush(PdfColor(154, 154, 154)));

  graphics.drawString('WhatsApp Number', PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
    bounds: Rect.fromLTWH(labelX, columnY + 2 * rowHeight, 90, rowHeight), brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  graphics.drawString("${_phoneController.text}", PdfStandardFont(PdfFontFamily.helvetica, 12),
    bounds: Rect.fromLTWH(valueX, columnY + 2 * rowHeight, 120, rowHeight), brush: PdfSolidBrush(PdfColor(154, 154, 154)));

  final double rightLabelX = pageSize.width / 2 + 10;
  final double rightValueX = rightLabelX + 90;

  graphics.drawString('Booked On', PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
    bounds: Rect.fromLTWH(rightLabelX, columnY, 80, rowHeight), brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  graphics.drawString("bookedOnDate", PdfStandardFont(PdfFontFamily.helvetica, 12),
    bounds: Rect.fromLTWH(rightValueX, columnY, 70, rowHeight), brush: PdfSolidBrush(PdfColor(154, 154, 154)));
  graphics.drawString("bookedOnTime", PdfStandardFont(PdfFontFamily.helvetica, 12),
    bounds: Rect.fromLTWH(rightValueX + 75, columnY, 50, rowHeight), brush: PdfSolidBrush(PdfColor(154, 154, 154)));

  graphics.drawString('Treatment Date', PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
    bounds: Rect.fromLTWH(rightLabelX, columnY + rowHeight, 90, rowHeight), brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  graphics.drawString("${_dateController.text}", PdfStandardFont(PdfFontFamily.helvetica, 12),
    bounds: Rect.fromLTWH(rightValueX, columnY + rowHeight, 70, rowHeight), brush: PdfSolidBrush(PdfColor(154, 154, 154)));

  graphics.drawString('Treatment Time', PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
    bounds: Rect.fromLTWH(rightLabelX, columnY + 2 * rowHeight, 90, rowHeight), brush: PdfSolidBrush(PdfColor(0, 0, 0)));
  graphics.drawString("${_timeController.text}", PdfStandardFont(PdfFontFamily.helvetica, 12),
    bounds: Rect.fromLTWH(rightValueX, columnY + 2 * rowHeight, 70, rowHeight), brush: PdfSolidBrush(PdfColor(154, 154, 154)));

  y += 3 * rowHeight + 15;

  // Treatments Table Section Title
  graphics.drawString(
    'Treatments',
    sectionTitleFont,
    bounds: Rect.fromLTWH(40, y, pageSize.width - 80, 20),
  );
  y += 30;
graphics.drawLine(
  PdfPen(PdfColor(154, 154, 154), width: 1, dashStyle: PdfDashStyle.dot, lineCap: PdfLineCap.square),
  Offset(40, y),
  Offset(pageSize.width - 40, y),
);



y += 10; 
  // ---------------- TABLE WITHOUT LINES ------------------
  final PdfColor headerGreen = PdfColor(0, 149, 94);
  final PdfColor cellGray = PdfColor(154, 154, 154);
  final PdfGrid grid = PdfGrid();
  grid.columns.add(count: 5);
  grid.headers.add(1);

  final PdfGridRow headerRow = grid.headers[0];
  headerRow.cells[0].value = 'Treatment';
  headerRow.cells[1].value = 'Price';
  headerRow.cells[2].value = 'Males';
  headerRow.cells[3].value = 'Females';
  headerRow.cells[4].value = 'Total';

  // Set header style: green, bold, NO borders
  for (var i = 0; i < 5; i++) {
    headerRow.cells[i].style = PdfGridCellStyle(
      font: PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
      textBrush: PdfSolidBrush(headerGreen),
      cellPadding: PdfPaddings(left: 5, right: 5, top: 6, bottom: 6),
      borders: PdfBorders(
        left: PdfPens.transparent, top: PdfPens.transparent, right: PdfPens.transparent, bottom: PdfPens.transparent,
      ),
    );
  }

  // Data rows: gray text, NO borders
  for (var treatment in addTreatment) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = treatment['name'];
    row.cells[1].value = treatment['price'].toString();
    row.cells[2].value = treatment['male'].toString();
    row.cells[3].value = treatment['female'].toString();
    row.cells[4].value = treatment['total'].toString();

    for (var i = 0; i < 5; i++) {
      row.cells[i].style = PdfGridCellStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 12),
        textBrush: PdfSolidBrush(cellGray),
        cellPadding: PdfPaddings(left: 5, right: 5, top: 6, bottom: 6),
        borders: PdfBorders(
          left: PdfPens.transparent, top: PdfPens.transparent, right: PdfPens.transparent, bottom: PdfPens.transparent,
        ),
      );
    }
  }

  // Grid style does NOT include borderPen in Flutter!
  grid.style = PdfGridStyle(
    cellPadding: PdfPaddings(left: 5, right: 5, top: 6, bottom: 6),
    font: PdfStandardFont(PdfFontFamily.helvetica, 12),
  );

  final PdfLayoutResult result = grid.draw(
    page: page,
    bounds: Rect.fromLTWH(40, y, pageSize.width - 40, 0),
  )!;

  y = result.bounds.bottom + 10;
graphics.drawLine(
  PdfPen(PdfColor(154, 154, 154), width: 1, dashStyle: PdfDashStyle.dot, lineCap: PdfLineCap.square),
  Offset(40, y),
  Offset(pageSize.width - 40, y),
);

  graphics.drawString(
    'Total Amount: ₹${_totalAmountController.text}',
    sectionTitleFont,
    bounds: Rect.fromLTWH(40, y, pageSize.width - 80, 25),
  );
// --- Amount Summary Variables (replace with your values) ----
final totalAmount = "₹7,620";
final discount = "₹500";
final advance = "₹1,200";
final balance = "₹5,920";

// --- Positioning ---
final summaryRight = pageSize.width - 60;
final double summaryWidth = 150;
// double y = ; // y should be where you want the summary box, e.g. after table

// --- Amount Section (all right-aligned, black or bold where needed) ---
graphics.drawString(
  'Total Amount',
  PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
  bounds: Rect.fromLTWH(summaryRight - summaryWidth, y, summaryWidth, 16),
  format: PdfStringFormat(alignment: PdfTextAlignment.right),
);
graphics.drawString(
  totalAmount,
  PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
  bounds: Rect.fromLTWH(summaryRight, y, 55, 16),
  format: PdfStringFormat(alignment: PdfTextAlignment.right),
);
y += 20;

graphics.drawString(
  'Discount',
  PdfStandardFont(PdfFontFamily.helvetica, 12),
  bounds: Rect.fromLTWH(summaryRight - summaryWidth, y, summaryWidth, 16),
  format: PdfStringFormat(alignment: PdfTextAlignment.right),
);
graphics.drawString(
  discount,
  PdfStandardFont(PdfFontFamily.helvetica, 12),
  bounds: Rect.fromLTWH(summaryRight, y, 55, 16),
  format: PdfStringFormat(alignment: PdfTextAlignment.right),
);
y += 20;

graphics.drawString(
  'Advance',
  PdfStandardFont(PdfFontFamily.helvetica, 12),
  bounds: Rect.fromLTWH(summaryRight - summaryWidth, y, summaryWidth, 16),
  format: PdfStringFormat(alignment: PdfTextAlignment.right),
);
graphics.drawString(
  advance,
  PdfStandardFont(PdfFontFamily.helvetica, 12),
  bounds: Rect.fromLTWH(summaryRight, y, 55, 16),
  format: PdfStringFormat(alignment: PdfTextAlignment.right),
);
y += 20;

// --- Dashed line divider ---
graphics.drawLine(
  PdfPen(PdfColor(154, 154, 154), width: 1, dashStyle: PdfDashStyle.dash),
  Offset(summaryRight - summaryWidth, y),
  Offset(pageSize.width - 40, y),
);
y += 15;

// --- BOLD Balance row ---
graphics.drawString(
  'Balance',
  PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
  bounds: Rect.fromLTWH(summaryRight - summaryWidth, y, summaryWidth, 16),
  format: PdfStringFormat(alignment: PdfTextAlignment.right),
);
graphics.drawString(
  balance,
  PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
  bounds: Rect.fromLTWH(summaryRight, y, 55, 16),
  format: PdfStringFormat(alignment: PdfTextAlignment.right),
);
y += 40;

// --- Thank you message ---
graphics.drawString(
  'Thank you for choosing us',
  PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold),
  bounds: Rect.fromLTWH(40, y, pageSize.width - 80, 22),
  brush: PdfSolidBrush(PdfColor(0, 180, 100)), // Green
  format: PdfStringFormat(alignment: PdfTextAlignment.right),
);
y += 22;

// --- Subtitle (faint, smaller) ---
graphics.drawString(
  "Your well-being is our commitment, and we're honored\nyou've entrusted us with your health journey",
  PdfStandardFont(PdfFontFamily.helvetica, 10),
  bounds: Rect.fromLTWH(40, y, pageSize.width - 80, 36),
  brush: PdfSolidBrush(PdfColor(154, 154, 154)),
  format: PdfStringFormat(alignment: PdfTextAlignment.right),
);
y += 35;

// --- Signature (as simple text or vector) ---
graphics.drawImage(sighn, Rect.fromLTWH(pageSize.width - 100, y, 100, 50) );

  // Save PDF bytes
  final pdfBytes = await document.save();
  document.dispose();

  // Save to file
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
  final file = File(filePath);
  await file.writeAsBytes(pdfBytes);

  return filePath;
}

}
