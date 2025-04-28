class TokenModel {
  final String token;

  TokenModel({required this.token});

  // BUKAN Map<String, dynamic> lagi, tapi dynamic
  factory TokenModel.fromJson(dynamic json) {
    return TokenModel(
      token: json.toString(), // json di sini adalah String
    );
  }
}
