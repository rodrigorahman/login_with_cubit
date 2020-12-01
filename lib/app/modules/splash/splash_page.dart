import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:login_with_cubit/app/modules/cubit/app_cubit.dart';

class SplashPage extends StatelessWidget {
  SplashPage() {
    final appCubit = Modular.get<AppCubit>();
    appCubit.checkLogged();

    appCubit.listen((state) {
      if (state.logged != null) {
        if (state.logged) {
          Modular.to.pushNamedAndRemoveUntil('/home', (_) => false);
        } else {
          Modular.to.pushNamedAndRemoveUntil('/login', (_) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splash'),
      ),
      body: Container(),
    );
  }
}
