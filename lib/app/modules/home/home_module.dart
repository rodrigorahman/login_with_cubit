import 'package:flutter_modular/flutter_modular.dart';
import 'package:login_with_cubit/app/modules/cubit/app_cubit.dart';
import 'package:login_with_cubit/app/repositories/gifs_repository.dart';
import 'cubit/home_cubit.dart';
import 'home_page.dart';

class HomeModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => GifRepository()),
        Bind((i) => HomeCubit(i()), singleton: false),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => HomePage()),
      ];

  static Inject get to => Inject<HomeModule>.of();
}
