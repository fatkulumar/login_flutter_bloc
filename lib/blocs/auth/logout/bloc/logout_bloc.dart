import 'package:flutter/material.dart';
import 'package:flutter_application_2/repositories/auth/logout_repository.dart';
import 'package:flutter_application_2/utils/token_storage_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutRepository logoutRepository;
  LogoutBloc(this.logoutRepository) : super(LogoutInitial()) {
    on<LogoutSubmited>((event, emit) async {
      emit(LogoutLoading()); // Perbaikan di sini
      try {
        final token = await TokenStorageUtil.getToken();
        final response = await logoutRepository.logout(token);

        if (response.code == 200 && response.success) {
          final tokenFromDevice = response.singleData?.token ?? "";

          await TokenStorageUtil.deleteToken();

          emit(
            LogoutSuccess(
              code: response.code,
              message: response.message,
              success: response.success,
              token: tokenFromDevice,
            ),
          );
        } else {
          final errorMap = response.errors ?? {};
          final errorText = errorMap.values.expand((e) => e).join('\n');

          emit(
            LogoutFailure(errorText.isNotEmpty ? errorText : response.message),
          );
        }
      } catch (e) {
        emit(LogoutFailure('Terjadi kesalahan saat logout: $e'));
      }
    });
  }
}
