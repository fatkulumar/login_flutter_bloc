import 'package:flutter/material.dart';
import 'package:flutter_application_2/repositories/auth/login_repository.dart';
import 'package:flutter_application_2/utils/token_storage_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;
  LoginBloc(this.loginRepository) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        final response = await loginRepository.login(
          event.email,
          event.password,
        );
        if (response.code == 200 && response.success) {
          final token = response.singleData?.token ?? '';
          await TokenStorageUtil.saveToken(token);
          emit(
            LoginSuccess(
              code: response.code,
              message: response.message,
              success: response.success,
              token: token,
            ),
          );
        } else {
          // Ambil error dari response.errors
          final errorMap = response.errors ?? {};
          final errorText = errorMap.values.expand((e) => e).join('\n');

          emit(
            LoginFailure(
              errorText.isNotEmpty
                  ? errorText
                  : response.message,
            ),
          );

          emit(
            LoginFailureWithFields(
              emailError: errorMap['email']?.join(', '),
              passwordError: errorMap['password']?.join(', '),
            ),
          );
        }
      } catch (e) {
        emit(LoginFailure('Terjadi kesalahan saat login: $e'));
      }
    });
  }
}
