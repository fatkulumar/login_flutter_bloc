import 'package:flutter/material.dart';
import 'package:flutter_application_2/repositories/auth/register_repository.dart';
import 'package:flutter_application_2/utils/token_storage_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository registerRepository;
  RegisterBloc(this.registerRepository) : super(RegisterInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterLoading());
      try {
        final response = await registerRepository.register(event.email, event.name, event.password, event.passwordConfimation);
        if (response.code == 200) {
          var token = response.singleData?.token ?? '';
          await TokenStorageUtil.saveToken(token);
          emit(
            RegisterSuccess(
              code: response.code,
              message: response.message,
              success: response.success,
              token: response.singleData?.token ?? '',
            ),
          );
        }
      } catch (e) {
        emit(RegisterFailure('Gagal login: $e'));
      }
    });
  }
}
