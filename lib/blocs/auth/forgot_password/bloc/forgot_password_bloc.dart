import 'package:flutter/material.dart';
import 'package:flutter_application_2/repositories/auth/forgot_password_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordRepository forgotPasswordRepository;
  ForgotPasswordBloc(this.forgotPasswordRepository) : super(ForgotPasswordInitial()) {
    on<ForgotPassword>((event, emit) async {
      emit(ForgotPasswordLoading());
      try {
        print('submit forgot');
        final response = await forgotPasswordRepository.forgotPassword(event.email);
       if (response.code == 200 && response.success) {
          final token = response.singleData?.status ?? '';
          emit(
            ForgotPasswordSuccess(
              code: response.code,
              message: response.message,
              success: response.success,
              data: token,
            ),
          );
        } else {
          // Ambil error dari response.errors
          final errorMap = response.errors ?? {};
          final errorText = errorMap.values.expand((e) => e).join('\n');

          emit(
            ForgotPasswordFailure(
              errorText.isNotEmpty
                  ? errorText
                  : response.message,
            ),
          );

          emit(
            ForgotPasswordFailureWithFields(
              emailError: errorMap['email']?.join(', '),
              passwordError: errorMap['password']?.join(', '),
            ),
          );
        }

        print(response);
      } catch (e) {
        emit(ForgotPasswordFailure('Terjadi Kesalahan $e'));
      }
    });
  }
}
