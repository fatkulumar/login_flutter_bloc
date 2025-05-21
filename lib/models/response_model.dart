import 'package:flutter_application_2/models/data_model.dart';

class ResponseModel<T> {
  final bool success;
  final int code;
  final String message;
  final DataModel<T>? data;
  final T? singleData; // Untuk objek tunggal
  final Map<String, List<String>>? errors;

  ResponseModel({
    required this.success,
    required this.code,
    required this.message,
    this.data,
    this.singleData, // Menambahkan singleData untuk objek tunggal
    this.errors,
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
      data: DataModel<T>(
        currentPage: 1,
        data:
            (json['data'] as List)
                .map((item) => fromJsonT(item as Map<String, dynamic>))
                .toList(),
        firstPageUrl: '',
        from: 0,
        lastPage: 1,
        lastPageUrl: '',
        links: [],
        nextPageUrl: null,
        path: '',
        perPage: 10,
        prevPageUrl: null,
        to: 0,
        total: 0,
      ),
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