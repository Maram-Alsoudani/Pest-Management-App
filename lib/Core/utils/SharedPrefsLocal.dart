import 'dart:convert';
import 'package:bug_away/Features/register/data/models/user_model_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsLocal {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveData(
      {required String key, required UserAndAdminModelDto model}) async {
    await prefs.setString(key, jsonEncode(model.toFireStore()));
  }

  static UserAndAdminModelDto? getData({required String key}) {
    String? jsonString = prefs.getString(key);
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return UserAndAdminModelDto.fromFireStore(jsonMap);
    }
    return null;
  }

  static Future<void> removeData({required String key}) async {
    await prefs.remove(key);
  }
}
