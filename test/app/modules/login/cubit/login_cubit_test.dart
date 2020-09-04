import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:login_with_cubit/app/modules/login/cubit/login_cubit.dart';
import 'package:login_with_cubit/app/repositories/login_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MockLoginRepository extends Mock implements LoginRepository {}

void main() {

  LoginRepository _loginRepository;

  setUp(() {
    _loginRepository = MockLoginRepository();
    SharedPreferences.setMockInitialValues({});
  });

  blocTest<LoginCubit, LoginState>(
    'Login com Sucesso',
    build: (){
      when(_loginRepository.checkLogin(any, any)).thenAnswer((_) async => 'TOKEN');
      return LoginCubit(_loginRepository);
    },
    act: (cubit) => cubit.login('login', 'loginSenha'),
    expect: [
      LoginLoadingState(),
      LoginSuccessState(),
    ]
  );
}
