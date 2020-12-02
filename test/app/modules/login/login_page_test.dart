import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_with_cubit/app/modules/login/cubit/login_cubit.dart';
import 'package:login_with_cubit/app/modules/login/login_module.dart';
import 'package:login_with_cubit/app/modules/login/login_page.dart';
import 'package:login_with_cubit/app/repositories/login_repository.dart';
import 'package:login_with_cubit/app/shared/user_not_found_exception.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/widget_helper.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  LoginRepository _loginRepository;
  NavigatorObserver _navigatorObserver;

  setUp(() {
    _loginRepository = MockLoginRepository();
    _navigatorObserver = MockNavigatorObserver();
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Login Erro ', (tester) async {
    when(_loginRepository.checkLogin(any, any)).thenThrow(UserNotFoundException());

    initModule(LoginModule(), changeBinds: [
      Bind((i) => LoginCubit(_loginRepository), singleton: false),
    ]);

    // Quando não preciso adicionar o navigatorObservers
    await tester.pumpWidget(buildTestableWidget(LoginPage()));

    await enterTextByName(tester, TextFormField, 'Login', 'rodrigorahman');
    await enterTextByName(tester, TextFormField, 'password', 'rodrigo123');

    await tabButtonByText(tester, RaisedButton, 'Logar');

    await tester.pump();

    expect(find.byType(Overlay), findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 2));
  });

  testWidgets('Login Sucesso ', (tester) async {
    when(_loginRepository.checkLogin(any, any)).thenAnswer((_) => Future.delayed(Duration(seconds: 2), () => 'TOKEN' ));

    initModule(LoginModule(), changeBinds: [
      Bind((i) => LoginCubit(_loginRepository), singleton: false),
    ]);

    await tester.pumpWidget(MaterialApp(
      home: LoginPage(),
      initialRoute: '/',
      navigatorKey: Modular.navigatorKey,
      onGenerateRoute: Modular.generateRoute,
      navigatorObservers: [_navigatorObserver],
    ));

   await enterTextByName(tester, TextFormField, 'Login', 'rodrigorahman');
    await enterTextByName(tester, TextFormField, 'password', 'rodrigo123');

    await tabButtonByText(tester, RaisedButton, 'Logar');
    
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(Duration(seconds: 2));
    
    verify(_navigatorObserver.didPush(any, any)).called(2);

    
    await tester.pumpAndSettle(Duration(seconds: 2));
  });
}
