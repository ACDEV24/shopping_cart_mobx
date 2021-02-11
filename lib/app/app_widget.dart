import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shopping_cart_mobx/app/app_controller.dart';

class AppWidget extends StatelessWidget {

  final AppController controller;
  const AppWidget(this.controller);

  @override
  Observer build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);

    return Observer(
      builder: (_) => (this.controller.brightness == null) ? Material(
        child: Center(
          child: FadeIn()
        )
      ) : MaterialApp(
        navigatorKey: Modular.navigatorKey,
        title: 'Go Machin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: this.controller.brightness,
          primaryColor: this.controller.darkBlueColor,
          secondaryHeaderColor: this.controller.skyBlueColor,
          // scaffoldBackgroundColor: controller.backgroundColor
        ),
        initialRoute: '/',
        onGenerateRoute: Modular.generateRoute
      )
    );
  }
}
