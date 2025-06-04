part of 'logout_bloc.dart';

@immutable
sealed class LogoutState {}

final class LogoutInitial extends LogoutState {}
final class LogoutLoading extends LogoutState {}
final class LogoutLoaded extends LogoutState {}

final class LogoutSuccess extends LogoutState {
  final bool success;
  final int code;
  final String message;
  final String token;

  LogoutSuccess({
    required this.success,
    required this.code,
    required this.message,
    required this.token,
  });
}

final class LogoutFailure extends LogoutState {
  final String message;

  LogoutFailure(this.message);
}
