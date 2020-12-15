import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_with_cubit/app/modules/login/cubit/login_cubit.dart';
import 'package:login_with_cubit/app/modules/login/login_module.dart';
import 'package:login_with_cubit/app/modules/login/login_page.dart';
import 'package:login_with_cubit/app/repositories/login_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/widget_helper.dart';

class MockLoginRepository extends Mock implements ILoginRepository {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {

  // Declaracoes
  ILoginRepository _repository;
  NavigatorObserver _navigator;

  // SetUp
  setUp((){
    _repository = MockLoginRepository();
    _navigator = MockNavigatorObserver();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Login Sucesso', (tester) async {
    // Preparação
    when(_repository.checkLogin(any, any)).thenAnswer((_) {
      return Future.delayed(Duration(seconds: 2), () => 'TOKEN');
    });

    initModule(LoginModule(), changeBinds: [
      Bind((i) => LoginCubit(_repository), singleton: false),
    ]);

    // Execucao
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(),
        initialRoute: '/',
        navigatorKey: Modular.navigatorKey,
        onGenerateRoute: Modular.generateRoute,
        navigatorObservers: [_navigator],
      )
    );

    await enterTextByName(tester, TextFormField, 'Login', 'rodrigo');
    await enterTextByName(tester, TextFormField, 'password', 'rodrigo123');

    final botao = find.widgetWithText(RaisedButton, 'Logar');
    await tester.tap(botao);

    await tester.pump();
    // Verificação
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(Duration(seconds: 2));

    verify(_navigator.didPush(any, any)).called(2);
    await tester.pump();
  });
}