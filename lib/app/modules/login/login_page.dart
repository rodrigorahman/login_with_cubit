import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'cubit/login_cubit.dart';

class LoginPage extends StatelessWidget {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: CubitProvider(
          create: (context) => Modular.get<LoginCubit>(),
          child: buildForm(),
        ),
      ),
    );
  }

  Widget buildForm() {
    return CubitConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginErrorState) {
          FlutterToast(context).showToast(
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.red,
              child: Text(
                state.error,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        if (state is LoginSuccessState) {
          Modular.to.pushNamedAndRemoveUntil('/', (_) => false);
        }
      },
      builder: (context, state) {
        print(state);
        return Column(
          children: <Widget>[
            if (state is LoginLoadingState) CircularProgressIndicator(),
            TextFormField(
              controller: loginController,
              decoration: InputDecoration(labelText: 'Login'),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'password'),
            ),
            RaisedButton(
              onPressed: () => context.cubit<LoginCubit>().login(loginController.text, passwordController.text),
              child: Text('Logar'),
            )
          ],
        );
      },
    );
  }
}
