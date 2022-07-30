import 'package:shared_preferences/shared_preferences.dart';

class SettingManager {
  late final SharedPreferences _prefs;

  Future<void> update() async {
    _prefs = await SharedPreferences.getInstance();
  }

  get prefs => _prefs;

  int? getInt(String key) => _prefs.getInt(key);
  String? getString(String key) => _prefs.getString(key);
  bool? getBool(String key) => _prefs.getBool(key);
  double? getDoube(String key) => _prefs.getDouble(key);
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  void setInt(String key, int value) {_prefs.setInt(key, value);}
  void setString(String key, String value) {_prefs.setString(key, value);}
  void setBool(String key, bool value) {_prefs.setBool(key, value);}
  void setDouble(String key, double value) {_prefs.setDouble(key, value);}
  void setStringList(String key, List<String> value) {_prefs.setStringList(key, value);}

  void remove(String key) {_prefs.remove(key);}
}