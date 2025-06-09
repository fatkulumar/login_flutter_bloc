part of 'forgot_password_bloc.dart';

@immutable
sealed class ForgotPasswordState {}

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordLoading extends ForgotPasswordState {}

final class ForgotPasswordSuccess extends ForgotPasswordState {
  final bool success;
  final int code;
  final String message;
  final String data;

  ForgotPasswordSuccess({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });
}
final class ForgotPasswordFailure extends ForgotPasswordState {
  final String message;
  ForgotPasswordFailure(this.message);
}

class ForgotPasswordFailureWithFields extends ForgotPasswordState {
  final String? emailError;
  final String? passwordError;

  ForgotPasswordFailureWithFields({this.emailError, this.passwordError});
}