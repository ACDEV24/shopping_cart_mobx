import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:shopping_cart_mobx/app/app_widget.dart';
import 'package:shopping_cart_mobx/app/modules/home/home_module.dart';
import 'package:shopping_cart_mobx/preferences/user_preferences.dart';

import 'app_controller.dart';

class AppModule extends MainModule {

  @override
  List<Bind> get binds => [
    Bind((i) => AppController(
      prefs: i.get<UserPreferences>(),
      darkBlueColor: const Color(0xff2C3D63),
      skyBlueColor: const Color(0xff3FA9F5),
      brownColor: const Color(0xff282828),
    )),
    Bind((i) => UserPreferences()),
  ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, module: HomeModule()),
  ];

  @override
  Widget get bootstrap => AppWidget(to.get<AppController>());

  static Inject get to => Inject<AppModule>.of();
}
