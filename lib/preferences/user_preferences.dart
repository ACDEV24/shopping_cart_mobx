import 'package:localstorage/localstorage.dart';

class UserPreferences {
  
  static final UserPreferences _singleton = UserPreferences._();

  factory UserPreferences() => _singleton;

  UserPreferences._();

  LocalStorage _prefs;

  Future<void> init() async {
    this._prefs = LocalStorage('data');
    await this._prefs.ready;
  }

  String get id => this._prefs.getItem('id') ?? '';
  set id(String value) => this._prefs.setItem('id', value);

  bool get isLogged => this._prefs.getItem('isLogged') ?? false;
  set isLogged(bool value) => this._prefs.setItem('isLogged', value);

  bool get isFirstTime => this._prefs.getItem('isFirstTime') ?? true;
  set isFirstTime(bool value) => this._prefs.setItem('isFirstTime', value);

  bool get isDark => this._prefs.getItem('isDark') ?? false;
  set isDark(bool value) => this._prefs.setItem('isDark', value);
}