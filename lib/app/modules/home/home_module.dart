import 'package:dio/dio.dart';
import 'package:shopping_cart_mobx/app/utils/contants.dart';

import '../../app_controller.dart';
import 'home_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_page.dart';
import 'home_repository.dart';

class HomeModule extends ChildModule {

  @override
  List<Bind> get binds => [
    Bind((i) => HomeController(
      app: i.get<AppController>(),
      repository: i.get<HomeRepository>()
    )),
    Bind((i) => HomeRepository(
      dio: i.get<Dio>()
    )),
    Bind((i) => Dio(baseOptions)),
  ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, child: (_, args) => HomePage()),
  ];

  static Inject get to => Inject<HomeModule>.of();
}
