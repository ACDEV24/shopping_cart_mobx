import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shopping_cart_mobx/preferences/user_preferences.dart';

part 'app_controller.g.dart';

@Injectable()
class AppController = _AppControllerBase with _$AppController;

abstract class _AppControllerBase with Store {

  final Color darkBlueColor;
  final Color brownColor;
  final Color skyBlueColor;
  final UserPreferences prefs;

  _AppControllerBase({
    this.darkBlueColor,
    this.brownColor,
    this.skyBlueColor,
    this.prefs
  }) {
    this.loadTheme();
  }

  @observable
  Brightness brightness;

  @computed
  Color get backgroundColor => (this.isDark) ? Colors.grey[850] : Color(0xfffafafa);

  @computed
  bool get isDark => this.brightness == Brightness.dark;

  @computed
  Color get textColor => (this.isDark) ? Colors.white : this.brownColor;

  Color colorValidator(Color color) => (this.isDark) ? Colors.white : color;

  @computed
  Color get darkBlueColorValidated => (this.isDark) ? Colors.white : this.darkBlueColor;

  @action 
  void changeTheme() {

    if(this.isDark) this.brightness = Brightness.light;
    else this.brightness = Brightness.dark;

    this.savePreferences();
  }

  void savePreferences() => this.prefs.isDark = this.isDark;

  void loadTheme() async {

    await this.prefs.init();

    if(this.prefs.isDark) this.brightness = Brightness.dark;
    else this.brightness = Brightness.light;

  }
}
