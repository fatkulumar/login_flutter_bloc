part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}
final class LoginSuccess extends LoginState {
  final bool success;
  final int code;
  final String message;
  final String token;

  LoginSuccess({
    required this.success,
    required this.code,
    required this.message,
    required this.token,
  });
}
final class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);
}

class LoginFailureWithFields extends LoginState {
  final String? emailError;
  final String? passwordError;

  LoginFailureWithFields({this.emailError, this.passwordError});
}
