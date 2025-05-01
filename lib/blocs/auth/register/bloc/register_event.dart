part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String name;
  final String password;
  final String passwordConfimation;

  RegisterSubmitted({required this.email, required this.name, required this.password, required this.passwordConfimation});
}