import 'package:flutter_application_2/models/data_model.dart';

class ResponseModel<T> {
  final bool success;
  final int code;
  final String message;
  final DataModel<T>? data;
  final T? singleData; // Untuk objek tunggal

  ResponseModel({
    required this.success,
    required this.code,
    required this.message,
    this.data,
    this.singleData, // Menambahkan singleData untuk objek tunggal
  });

  // Untuk DataModel (Paginasi)
  factory ResponseModel.fromJsonForDataModel(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ResponseModel<T>(
      success: json['success'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? 'No Message',
      data:
          json['data'] != null
              ? DataModel<T>.fromJson(json['data'], fromJsonT)
              : null,
    );
  }

  // Untuk objek tunggal (misalnya UserModel)
  factory ResponseModel.fromJsonForSingle(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ResponseModel<T>(
      success: json['success'] ?? false,
      code: json['code'] ?? 0,
      message: json['message'] ?? 'No Message',
      singleData: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}