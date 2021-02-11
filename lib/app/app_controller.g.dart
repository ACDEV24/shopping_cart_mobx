// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_controller.dart';

// **************************************************************************
// InjectionGenerator
// **************************************************************************

final $AppController = BindInject(
  (i) => AppController(
      darkBlueColor: i<Color>(),
      brownColor: i<Color>(),
      skyBlueColor: i<Color>(),
      prefs: i<UserPreferences>()),
  singleton: true,
  lazy: true,
);

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppController on _AppControllerBase, Store {
  Computed<Color> _$backgroundColorComputed;

  @override
  Color get backgroundColor => (_$backgroundColorComputed ??= Computed<Color>(
          () => super.backgroundColor,
          name: '_AppControllerBase.backgroundColor'))
      .value;
  Computed<bool> _$isDarkComputed;

  @override
  bool get isDark => (_$isDarkComputed ??=
          Computed<bool>(() => super.isDark, name: '_AppControllerBase.isDark'))
      .value;
  Computed<Color> _$textColorComputed;

  @override
  Color get textColor =>
      (_$textColorComputed ??= Computed<Color>(() => super.textColor,
              name: '_AppControllerBase.textColor'))
          .value;
  Computed<Color> _$darkBlueColorValidatedComputed;

  @override
  Color get darkBlueColorValidated => (_$darkBlueColorValidatedComputed ??=
          Computed<Color>(() => super.darkBlueColorValidated,
              name: '_AppControllerBase.darkBlueColorValidated'))
      .value;

  final _$brightnessAtom = Atom(name: '_AppControllerBase.brightness');

  @override
  Brightness get brightness {
    _$brightnessAtom.reportRead();
    return super.brightness;
  }

  @override
  set brightness(Brightness value) {
    _$brightnessAtom.reportWrite(value, super.brightness, () {
      super.brightness = value;
    });
  }

  final _$_AppControllerBaseActionController =
      ActionController(name: '_AppControllerBase');

  @override
  void changeTheme() {
    final _$actionInfo = _$_AppControllerBaseActionController.startAction(
        name: '_AppControllerBase.changeTheme');
    try {
      return super.changeTheme();
    } finally {
      _$_AppControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
brightness: ${brightness},
backgroundColor: ${backgroundColor},
isDark: ${isDark},
textColor: ${textColor},
darkBlueColorValidated: ${darkBlueColorValidated}
    ''';
  }
}
