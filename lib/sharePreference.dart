import 'package:shared_preferences/shared_preferences.dart';

import 'Utils/App_utils.dart';

class PreferenceManager {
  late SharedPreferences sharedPreferences;
  PreferenceManager() {
    SharedPreferences.getInstance().then((value) => sharedPreferences = value);
  }

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // set data in preference
  Future<bool> remove() async {
    print("remove preferences");
    //SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.clear();
  }

  // set data in preference
  Future<bool> setPref(String key, String value) async {
    //SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(key, value);
  }

  // get data in preference
  Future<String> getPref(String key) async {
    //SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key) ?? "";
  }

  String getId() {
    return sharedPreferences.getString(URLConstants.id) ?? '';
  }
}
