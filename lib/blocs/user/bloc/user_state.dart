part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}
final class UserLoading extends UserState {}
final class UserLoaded extends UserState {
  final bool success;
  final int code;
  final String message;
  final UserModel data;

  UserLoaded({
    required this.success,
    required this.code,
    required this.message,
    required this.data
  });
}

final class UserFailure extends UserState {
  final String message;
  UserFailure(this.message);
}
