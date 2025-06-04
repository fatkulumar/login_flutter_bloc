part of 'logout_bloc.dart';

@immutable
sealed class LogoutEvent {}

class LoadLogout extends LogoutEvent {}
class LogoutSubmited extends LogoutEvent {}