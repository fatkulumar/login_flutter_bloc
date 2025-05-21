part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class LoadUser extends UserEvent {}