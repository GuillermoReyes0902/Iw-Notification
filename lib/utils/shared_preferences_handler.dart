import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHandler {
  static const String userId = "USER_ID";
  static const String userName = "USER_NAME";
  static const String userImage = "USER_PHOTO";

  static Future setUser(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userId, user.id);
    await prefs.setString(userName, user.name);
    await prefs.setString(userImage, user.photo);
  }

  static Future deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(userId);
    await prefs.remove(userName);
    await prefs.remove(userImage);
  }

  static Future<UserModel?> getUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = prefs.getString(userId);
      var name = prefs.getString(userName);
      var photo = prefs.getString(userImage);
      if (id != null && name != null && photo != null) {
        return UserModel(id: id, name: name, photo: photo);
      }
    } catch (e) {
      debugPrint("Error al obtener los datos $e");
    }
    return null;
  }
}
