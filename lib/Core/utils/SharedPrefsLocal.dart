
import 'dart:convert';

import 'package:pesticides/Features/register/data/models/user_model_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsLocal{
  static late SharedPreferences prefs;
  static init()async{
    prefs=await SharedPreferences.getInstance();
  }


 static saveData({required String key , required UserAndAdminModelDto model})async{
     return await prefs.setString(key, jsonEncode(model.toFireStore()));

  }

  static UserAndAdminModelDto? getData({required String key}) {
    String? jsonString = prefs.getString(key); // get the data as a string
    if (jsonString != null) {
      Map<String, dynamic> jsonData = jsonDecode(jsonString); // decode the JSON
      var model = UserAndAdminModelDto.fromFireStore(jsonData); // convert it to the model
      return model;
    }
    return null; // return null if the key doesn't exist or data is not found
  }

}