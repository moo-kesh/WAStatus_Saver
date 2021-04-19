import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {
  static void setSharedPrefs(String path, String fileName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(fileName, path);
  }

  static Future<String> getSharedPrefs(String fileName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(fileName);
  }

  static Future<bool> isAvailable(String fileName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.containsKey(fileName);
  }

  static void removeSharedPref(String fileName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(fileName);
  }
}
