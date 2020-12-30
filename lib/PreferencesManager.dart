
import 'package:shared_preferences/shared_preferences.dart';

var USER_ID = "USER_ID";

// here we get SharedPreferences saved data
String getPref(String key){
  String data;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  _prefs.then((value) =>
      data = value.get(key)
  );
  return data;
}

// here we save data into SharedPreferences
void savePref(String key, String data){
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  _prefs.then((value) => value.setString(key, data));
}