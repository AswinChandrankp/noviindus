import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
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
import 'dart:ui' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart' as pw;


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
  List<String> alladress = ["Kozhikode", "Palakkad", "Thrissur", "Kannur"];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _executiveController = TextEditingController();
  final TextEditingController _paymentController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _discountAmountController = TextEditingController();
  final TextEditingController _advanceAmountController = TextEditingController();
  final TextEditingController _balanceAmountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  TextEditingController get nameController => _nameController;
  TextEditingController get executiveController => _executiveController;
  TextEditingController get paymentController => _paymentController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get totalAmountController => _totalAmountController;
  TextEditingController get discountAmountController => _discountAmountController;
  TextEditingController get advanceAmountController => _advanceAmountController;
  TextEditingController get balanceAmountController => _balanceAmountController;
  TextEditingController get dateController => _dateController;
  TextEditingController get timeController => _timeController;
  TextEditingController get detailsController => _detailsController;

  RegistrationProvider() {
    getTreatments();
    getBranch();
    getUser();
  }

  void getUser() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString(AppConstants.userKey);
    notifyListeners();
  }

  
double _calculateTotalAmount() {
  double total = 0.0;
  for (var treatment in addTreatment) {
    final totalValue = treatment['total'] as num? ?? 0;
    total += totalValue.toDouble();
  }
  return total.roundToDouble(); 
}


double _calculateBalance(double total, double discount, double advance) {
  final balance = total - discount - advance;
  return balance.roundToDouble(); 
}


void updateAmounts() {
  final total = _calculateTotalAmount();
  final discount = double.tryParse(_discountAmountController.text) ?? 0.0;
  final advance = double.tryParse(_advanceAmountController.text) ?? 0.0;
  final balance = _calculateBalance(total, discount, advance);

  _totalAmountController.text = total.toInt().toString(); 
  _balanceAmountController.text = balance.toInt().toString(); 
  notifyListeners();
}
  String? validateFields() {
    if (_nameController.text.isEmpty) {
      return "Name is required.";
    }
    if (_phoneController.text.isEmpty) {
      return "Please enter a valid phone number.";
    }
    if (_selectedadress == null || _selectedadress!.isEmpty) {
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
    
    final total = double.tryParse(_totalAmountController.text) ?? 0.0;
    final discount = double.tryParse(_discountAmountController.text) ?? 0.0;
    final advance = double.tryParse(_advanceAmountController.text) ?? 0.0;
    final expectedBalance = total - discount - advance;
    final currentBalance = double.tryParse(_balanceAmountController.text) ?? 0.0;
    if ((currentBalance - expectedBalance).abs() > 0.01) {
      return "Balance does not match total - discount - advance.";
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
   getTreatmentIds();
    updateAmounts(); 
    final validationMessage = validateFields();

    if (validationMessage != null) {
      CustomSnackbar.show(context: context, message: validationMessage, isSucces: false);
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      ResponseModel response = await _treatmentService.register(
        name: _nameController.text,
        excecutive: _userName ?? '',
        payment: _paymentController.text,
        phone: _phoneController.text,
        address: _selectedadress ?? '',
         totalAmount: _totalAmountController.text.toString(),
        discountAmount: _discountAmountController.text,
        advanceAmount: _advanceAmountController.text,
        balanceAmount: _balanceAmountController.text,
        dateNdTime: "${_dateController.text} ${_timeController.text}",
        male: _allMaleCount ?? '0',
        female: _allFemaleCount ?? '0',
        branch: _selectedBranch?.id.toString() ?? '',
        treatments: _selectedTreatmentIds ?? '',
        detail: _detailsController.text,
      );

      _isLoading = false;
      notifyListeners();

      if (response.success) {
        CustomSnackbar.show(context: context, message: response.message, isSucces: true);
        try {
          final filePath = await generateInvoicePDF();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => InvoiceViewerPage(filePath: filePath),
          ));
      
          CustomSnackbar.show(context: context, message: "Invoice  saved at: $filePath", isSucces: true);
          // clearAllData();
        } catch (e) {
         
             CustomSnackbar.show(context: context, message: "Failed to generate PDF: $e", isSucces: false);
   
        }
      } else {
        CustomSnackbar.show(context: context, message: response.message, isSucces: false);
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      CustomSnackbar.show(context: context, message: 'Registration failed: $e', isSucces: false);
    }
  }

  Future<void> getTreatments() async {
    _isLoading = true;
    notifyListeners();
    try {
      _treatments = await _treatmentService.getTreatments();
    } catch (e) {
      print('Error fetching treatments: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getBranch() async {
    _isLoading = true;
    notifyListeners();
    try {
      _branches = await _treatmentService.getBranch();
    } catch (e) {
      print('Error fetching branches: $e');
    }
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

  void setAddress(String address) {
    _selectedadress = address;
    notifyListeners();
  }

  void addTreatmentToList() {
    if (_selectedTreatment == null) return;
    if (_maleCount == 0 && _femaleCount == 0) return;

    try {
      addTreatment.add({
        "name": _selectedTreatment?.name ?? '',
        'price': _selectedTreatment?.price.toString() ?? '0',
        'treatmentid': _selectedTreatment?.id.toString() ?? '',
        'male': _maleCount.toString(),
        'female': _femaleCount.toString(),
        'total': (_maleCount + _femaleCount) * double.parse(_selectedTreatment?.price ?? '0'),
      });
      updateAmounts();
      clearCounts();
    } catch (e) {
      print('Error adding treatment: $e');
    }
  }

  void incrementMaleCount() {
    _maleCount++;
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

  void deleteTreatment(int index) {
    addTreatment.removeAt(index);
    updateAmounts();
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
    _detailsController.clear();
    addTreatment.clear();
    _allMaleCount = null;
    _allFemaleCount = null;
    _selectedBranch = null;
    _selectedTreatment = null;
    _selectedTreatmentIds = null;
    notifyListeners();
  }

  void getTreatmentIds() {
    List<int> maleTreatmentIds = [];
    List<int> femaleTreatmentIds = [];
    List<int> allTreatmentIds = [];

    for (var treatment in addTreatment) {
      try {
        maleTreatmentIds.add(int.parse(treatment['male'] ?? '0'));
        femaleTreatmentIds.add(int.parse(treatment['female'] ?? '0'));
        allTreatmentIds.add(int.parse(treatment['treatmentid'] ?? '0'));
      } catch (e) {
        print('Error parsing treatment data: $e');
        // Set defaults to avoid invalid data
        maleTreatmentIds.add(0);
        femaleTreatmentIds.add(0);
        allTreatmentIds.add(0);
      }
    }

    _allMaleCount = maleTreatmentIds.join(',');
    _allFemaleCount = femaleTreatmentIds.join(',');
    _selectedTreatmentIds = allTreatmentIds.join(',');
    notifyListeners();
  }

  Future<String> generateInvoicePDF() async {
    final pw.PdfDocument document = pw.PdfDocument();
    final pw.PdfPage page = document.pages.add();
    final pw.Size pageSize = page.getClientSize();
    final graphics = page.graphics;

    // Fonts
    final titleFont = pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 20, style: pw.PdfFontStyle.bold);
    final sectionTitleFont = pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 14, style: pw.PdfFontStyle.bold);
    final regularFont = pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 12);

    // Load logo and signature images
    final ByteData logoBytes = await rootBundle.load('assets/images/Asset.png');
    final ByteData sighnBytes = await rootBundle.load('assets/images/Vector 1.png');
    final Uint8List logoList = logoBytes.buffer.asUint8List();
    final Uint8List sighnList = sighnBytes.buffer.asUint8List();
    final logo = pw.PdfBitmap(logoList);
    final sighn = pw.PdfBitmap(sighnList);

    // ----------- HEADER SETUP -----------
    const double headerHeight = 120;
    final header = pw.PdfPageTemplateElement(pw.Rect.fromLTWH(0, 0, pageSize.width, headerHeight));

    header.graphics.drawRectangle(
      bounds: pw.Rect.fromLTWH(0, 0, pageSize.width, headerHeight),
    );


    const double logoWidth = 80;
    const double logoHeight = 80;
    const double logoMarginLeft = 40;
    final double logoPosY = (headerHeight - logoHeight) / 2;

    header.graphics.drawImage(logo, pw.Rect.fromLTWH(logoMarginLeft, logoPosY, logoWidth, logoHeight));

  
    header.graphics.drawString(
      'Cheepunkal P.O. Kumarakom, kottayam, Kerala - 686563\ne-mail: unknown@gmail.com\nMob: +91 9876543210 | +91 9786543210',
      pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 8),
      bounds: pw.Rect.fromLTWH(pageSize.width / 2, logoPosY + 15, pageSize.width / 2 - 40, logoHeight),
      brush: pw.PdfSolidBrush(pw.PdfColor(100, 128, 128)),
      format: pw.PdfStringFormat(
        alignment: pw.PdfTextAlignment.right,
        lineAlignment: pw.PdfVerticalAlignment.top,
      ),
    );

  
    header.graphics.drawString(
      'KUMARAKOM',
      pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 10),
      bounds: pw.Rect.fromLTWH(pageSize.width / 2, logoPosY, pageSize.width / 2 - 40, logoHeight),
      brush: pw.PdfSolidBrush(pw.PdfColor(0, 0, 0)),
      format: pw.PdfStringFormat(
        alignment: pw.PdfTextAlignment.right,
        lineAlignment: pw.PdfVerticalAlignment.top,
      ),
    );

  
    header.graphics.drawString(
      'GST No: 32AABCU9603R1ZW',
      pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 10),
      bounds: pw.Rect.fromLTWH(pageSize.width / 2, logoPosY + 50, pageSize.width / 2 - 40, logoHeight),
      brush: pw.PdfSolidBrush(pw.PdfColor(0, 0, 0)),
      format: pw.PdfStringFormat(
        alignment: pw.PdfTextAlignment.right,
        lineAlignment: pw.PdfVerticalAlignment.top,
      ),
    );

    document.template.top = header;

    
    header.graphics.drawLine(
      pw.PdfPen(pw.PdfColor(100, 128, 120), width: 0.5),
      pw.Offset(40, headerHeight - 1),
      pw.Offset(pageSize.width - 40, headerHeight - 1),
    );

    // ----------- FOOTER SETUP -----------
    const double footerHeight = 50;
    final footer = pw.PdfPageTemplateElement(pw.Rect.fromLTWH(0, 0, pageSize.width, footerHeight));

    footer.graphics.drawRectangle(
      bounds: pw.Rect.fromLTWH(0, 0, pageSize.width, footerHeight),
    );

    footer.graphics.drawLine(
      pw.PdfPen(pw.PdfColor(154, 154, 154), width: 1, dashStyle: pw.PdfDashStyle.dash),
      pw.Offset(40, 0),
      pw.Offset(pageSize.width - 40, 0),
    );

    footer.graphics.drawString(
      '"Booking amount is non-refundable, and its important to arrive on the allotted time for your treatment"',
      pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 9, style: pw.PdfFontStyle.regular),
      bounds: pw.Rect.fromLTWH(0, 15, pageSize.width, 20),
      brush: pw.PdfSolidBrush(pw.PdfColor(154, 154, 154)),
      format: pw.PdfStringFormat(alignment: pw.PdfTextAlignment.center),
    );

    document.template.bottom = footer;

    // ----------- BACKGROUND WATERMARK -----------
    graphics.setTransparency(0.1);
    const double watermarkWidth = 300;
    const double watermarkHeight = 300;
    final double watermarkX = (pageSize.width - watermarkWidth) / 2;
    final double watermarkY = (pageSize.height - watermarkHeight) / 2;

    graphics.drawImage(logo, pw.Rect.fromLTWH(watermarkX, watermarkY, watermarkWidth, watermarkHeight));
    graphics.setTransparency(1);

    // ----------- MAIN CONTENT -----------
    double y = headerHeight + 20;

    // Patient Details Title
    graphics.drawString(
      'Patient Details',
      sectionTitleFont,
      bounds: pw.Rect.fromLTWH(40, y, 150, 20),
      brush: pw.PdfSolidBrush(pw.PdfColor(0, 180, 100)),
    );
    y += 25;

    // Patient Info two columns
    final double labelX = 40;
    final double valueX = 110;
    final double columnY = y;
    final double rowHeight = 20;

    graphics.drawString(
      'Name',
      pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 12, style: pw.PdfFontStyle.bold),
      bounds: pw.Rect.fromLTWH(labelX, columnY, 60, rowHeight),
      brush: pw.PdfSolidBrush(pw.PdfColor(0, 0, 0)),
    );
    graphics.drawString(
      _nameController.text,
      pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 12),
      bounds: pw.Rect.fromLTWH(valueX, columnY, 120, rowHeight),
      brush: pw.PdfSolidBrush(pw.PdfColor(154, 154, 154)),
    );

    graphics.drawString(
      'Address',
      pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 12, style: pw.PdfFontStyle.bold),
      bounds: pw.Rect.fromLTWH(labelX, columnY + rowHeight, 60, rowHeight),
      brush: pw.PdfSolidBrush(pw.PdfColor(0, 0, 0)),
    );
    graphics.drawString(
      _selectedadress ?? '',
      pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 12),
      bounds: pw.Rect.fromLTWH(valueX, columnY + rowHeight, 120, rowHeight),
      brush: pw.PdfSolidBrush(pw.PdfColor(154, 154, 154)),
    );

    graphics.drawString(
      'WhatsApp Number',
      pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 12, style: pw.PdfFontStyle.bold),
      bounds: pw.Rect.fromLTWH(labelX, columnY + 2 * rowHeight, 90, rowHeight),
      brush: pw.PdfSolidBrush(pw.PdfColor(0, 0, 0)),
    );
    graphics.drawString(
      _phoneController.text,
      pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 12),
      bounds: pw.Rect.fromLTWH(valueX, columnY + 2 * rowHeight, 120, rowHeight),
      brush: pw.PdfSolidBrush(pw.PdfColor(154, 154, 154)),
    );

    final double rightLabelX = pageSize.width / 2 + 10;
    final double rightValueX = rightLabelX + 90;

    graphics.drawString(
      'Booked On',
      pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 12, style: pw.PdfFontStyle.bold),
      bounds: pw.Rect.fromLTWH(rightLabelX, columnY, 80, rowHeight),
      brush: pw.PdfSolidBrush(pw.PdfColor(0, 0, 0)),
    );
    graphics.drawString(
    DateFormat('dd/MM/yyyy | hh:mma').format(DateTime.now()),
    pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 12),
    bounds: pw.Rect.fromLTWH(rightValueX + 10, columnY, 120, rowHeight),
    brush: pw.PdfSolidBrush(pw.PdfColor(154, 154, 154)),
  );

    graphics.drawString(
      'Treatment Date',
      pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 12, style: pw.PdfFontStyle.bold),
      bounds: pw.Rect.fromLTWH(rightLabelX , columnY + rowHeight, 90, rowHeight),
      brush: pw.PdfSolidBrush(pw.PdfColor(0, 0, 0)),
    );
    graphics.drawString(
      _dateController.text,
      pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 12),
      bounds: pw.Rect.fromLTWH(rightValueX+ 10, columnY + rowHeight, 70, rowHeight),
      brush: pw.PdfSolidBrush(pw.PdfColor(154, 154, 154)),
    );

    graphics.drawString(
      'Treatment Time',
      pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 12, style: pw.PdfFontStyle.bold),
      bounds: pw.Rect.fromLTWH(rightLabelX, columnY + 2 * rowHeight, 90, rowHeight),
      brush: pw.PdfSolidBrush(pw.PdfColor(0, 0, 0)),
    );
    graphics.drawString(
      _timeController.text,
      
      pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 12),
      bounds: pw.Rect.fromLTWH(rightValueX+ 10, columnY + 2 * rowHeight, 70, rowHeight),
      brush: pw.PdfSolidBrush(pw.PdfColor(154, 154, 154)),
    );

    y += 3 * rowHeight + 15;

    // Treatments Table Section Title
    graphics.drawString(
      'Treatments',
      sectionTitleFont,
      bounds: pw.Rect.fromLTWH(40, y, pageSize.width - 80, 20),
    );
    y += 30;
    graphics.drawLine(
      pw.PdfPen(pw.PdfColor(154, 154, 154), width: 1, dashStyle: pw.PdfDashStyle.dot, lineCap: pw.PdfLineCap.square),
      pw.Offset(40, y),
      pw.Offset(pageSize.width - 40, y),
    );
    y += 10;

    // Table
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

 y += 20;
   
    final totalAmount = '₹${_totalAmountController.text}';
    final discount = '₹${_discountAmountController.text}';
    final advance = '₹${_advanceAmountController.text}';
    final balance = '₹${_balanceAmountController.text}';

    final double labelColWidth = 120;
    final double valueColWidth = 80;
    final double summaryStartX = pageSize.width - (labelColWidth + valueColWidth + 40);
    final rightAlign = pw.PdfStringFormat(alignment: pw.PdfTextAlignment.right);

    void drawSummaryRow(String label, String value, double yPos, {bool bold = false}) {
      final font = bold
          ? pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 12, style: pw.PdfFontStyle.bold)
          : pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 12);

      graphics.drawString(
        label,
        font,
        bounds: pw.Rect.fromLTWH(summaryStartX, yPos, labelColWidth, 20),
        format: rightAlign,
      );

      graphics.drawString(
        value,
        font,
        bounds: pw.Rect.fromLTWH(summaryStartX + labelColWidth, yPos, valueColWidth, 20),
        format: rightAlign,
      );
    }

    drawSummaryRow('Total Amount', totalAmount, y, bold: true);
    y += 20;
    drawSummaryRow('Discount', discount, y);
    y += 20;
    drawSummaryRow('Advance', advance, y);
    y += 20;

    graphics.drawLine(
      pw.PdfPen(pw.PdfColor(154, 154, 154), width: 1, dashStyle: pw.PdfDashStyle.dash),
      pw.Offset(summaryStartX, y),
      pw.Offset(pageSize.width - 40, y),
    );
    y += 15;

    drawSummaryRow('Balance', balance, y, bold: true);
    y += 40;

    // Thank you message
    graphics.drawString(
      'Thank you for choosing us',
      pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 16, style: pw.PdfFontStyle.bold),
      bounds: pw.Rect.fromLTWH(40, y, pageSize.width - 80, 22),
      brush: pw.PdfSolidBrush(pw.PdfColor(0, 180, 100)),
      format: pw.PdfStringFormat(alignment: pw.PdfTextAlignment.right),
    );
    y += 22;

    graphics.drawString(
      "Your well-being is our commitment, and we're honored\nyou've entrusted us with your health journey",
      pw.PdfStandardFont(pw.PdfFontFamily.helvetica, 10),
      bounds: pw.Rect.fromLTWH(40, y, pageSize.width - 80, 36),
      brush: pw.PdfSolidBrush(pw.PdfColor(154, 154, 154)),
      format: pw.PdfStringFormat(alignment: pw.PdfTextAlignment.right),
    );
    y += 35;

 
    graphics.drawImage(sighn, pw.Rect.fromLTWH(pageSize.width - 140, y, 100, 50));

    // Save PDF
    final pdfBytes = await document.save();
    document.dispose();

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    return filePath;
  }
}