import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:login_with_cubit/app/repositories/login_repository.dart';
import 'package:login_with_cubit/app/shared/user_not_found_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _repository;

  LoginCubit(this._repository) : super(LoginInitial());

  Future<void> login(String login, String password) async {
    try {
      emit(LoginLoadingState());
      final token = await _repository.checkLogin(login, password);
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setString('token', token);
      emit(LoginSuccessState());
    } on UserNotFoundException {
      emit(LoginErrorState('Login ou senha inválido'));
    } catch (e,s) {
      print(e);
      print(s);

      emit(LoginErrorState('Erro ao realizar Login'));
    }
  }
}
