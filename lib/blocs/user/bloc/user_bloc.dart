import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/user/user_model.dart';
import 'package:flutter_application_2/repositories/user/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  UserBloc(this.userRepository) : super(UserInitial()) {
    on<LoadUser>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userRepository.getUser();
        final user = response.singleData!;
        if (response.code == 200) {
          emit(
            UserLoaded(
              code: response.code,
              message: response.message,
              success: response.success,
              data: user,
            ),
          );
        }
      } catch (e) {
        emit(UserFailure('Failed get data: $e'));
      }
    });
  }
}
