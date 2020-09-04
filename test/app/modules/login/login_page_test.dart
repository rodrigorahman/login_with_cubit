
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

class MockLoginRepository extends Mock implements LoginRepository {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  LoginRepository loginRepository;
  MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    print('setUp');
    loginRepository = MockLoginRepository();
    mockNavigatorObserver = MockNavigatorObserver();
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    
  });

  testWidgets('login page ...', (tester) async {
    // prepare
    when(loginRepository.checkLogin(any, any)).thenThrow(UserNotFoundException());

    initModule(LoginModule(), changeBinds: [
      Bind((i) => LoginCubit(loginRepository), singleton: false),
    ]);

    Modular.get<LoginCubit>().login('login', 'password');

    await tester.pumpWidget(buildTestableWidget(LoginPage()));

    var login = find.widgetWithText(TextFormField, 'Login');
    await tester.enterText(login, 'rodrigo@teste.com.br');

    var senha = find.widgetWithText(TextFormField, 'password');
    await tester.enterText(senha, 'rodrigo');

    final botao = find.widgetWithText(RaisedButton, 'Logar');
    await tester.tap(botao);

    await tester.pump();
    expect(find.byType(Overlay), findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 1));
  });

  testWidgets('login sucesso ...', (tester) async {
    // prepare
    when(loginRepository.checkLogin(any, any)).thenAnswer((_) => Future.delayed(Duration(seconds: 1), () => 'TOKEN'));

    initModule(LoginModule(), changeBinds: [
      Bind((i) => LoginCubit(loginRepository), singleton: false),
    ]);

    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(),
        initialRoute: '/',
        navigatorKey: Modular.navigatorKey,
        onGenerateRoute: Modular.generateRoute,
        navigatorObservers: [mockNavigatorObserver],
      ),
    );

    var login = find.widgetWithText(TextFormField, 'Login');
    await tester.enterText(login, 'rodrigo@teste.com.br');

    var senha = find.widgetWithText(TextFormField, 'password');
    await tester.enterText(senha, 'rodrigo');

    // RaisedButton botao = find.widgetWithText(RaisedButton, 'Logar').evaluate().first.widget;
    final botao = find.widgetWithText(RaisedButton, 'Logar');
    await tester.tap(botao);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    verify(mockNavigatorObserver.didPush(any, any));
  });
}
