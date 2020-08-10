import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState.initial());

  Future<void> checkLogged() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    emit(AppState.logged(sp.containsKey('token')));
  }

}
