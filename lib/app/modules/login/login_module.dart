import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:login_with_cubit/app/modules/login/login_page.dart';
import 'package:login_with_cubit/app/repositories/login_repository.dart';

import 'cubit/login_cubit.dart';

class LoginModule extends ChildModule {
  @override
  List<Bind> get binds => [
    Bind((i) => LoginRepository(Dio())),
    Bind((i) => LoginCubit(i()), singleton: false)
  ];

  @override
  List<Router> get routers => [
        Router(
          Modular.initialRoute,
          child: (context, args) => LoginPage(),
        ),
      ];

  static Inject get to => Inject<LoginModule>.of();
}
