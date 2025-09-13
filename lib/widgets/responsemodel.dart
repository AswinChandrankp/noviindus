class ResponseModel {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  ResponseModel({
    required this.success,
    required this.message,
    this.data,
  });
}
