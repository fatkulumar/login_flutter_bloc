class ForgotPasswordModel {
  final String status;

  ForgotPasswordModel({required this.status});

  factory ForgotPasswordModel.fromJson(dynamic json) {
    return ForgotPasswordModel(status: json.toString());
  }
}