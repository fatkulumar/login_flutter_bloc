part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}
final class RegisterSuccess extends RegisterState {
  final bool success;
  final int code;
  final String message;
  final String token;

  RegisterSuccess({
    required this.success,
    required this.code,
    required this.message,
    required this.token,
  });
}
final class RegisterFailure extends RegisterState {
  final String message;
  RegisterFailure(this.message);
}