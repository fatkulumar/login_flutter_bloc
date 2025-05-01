import 'package:flutter/material.dart';
import 'package:flutter_application_2/repositories/auth/login_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;
  LoginBloc(this.loginRepository) : super(LoginInitial()) {
   on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        final response = await loginRepository.login(event.email, event.password);
        if (response.code == 200) {
          emit(
            LoginSuccess(
              code: response.code,
              message: response.message,
              success: response.success,
              token: response.singleData?.token ?? '',
            ),
          );
        }
      } catch (e) {
        emit(LoginFailure('Gagal login: $e'));
      }
    });
  }
}
