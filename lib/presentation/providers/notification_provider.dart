import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/user_model.dart';
//import 'package:iwproject/utils/local_notification_handler.dart';

class NotificationProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  TextEditingController contenidoCtrl = TextEditingController();

  List<UserModel> users = [];

  void setUsers(List<UserModel> newReminders) {
    users = newReminders;
    notifyListeners();
  }

  Future<bool> saveReminder() async {
    if (formKey.currentState!.validate()) {
      try {
        // Cloud Firestore
        final remindersRef = FirebaseFirestore.instance.collection('reminders');
        await remindersRef.add({
          //TODO añadir los otros campos
          "content": contenidoCtrl.text.trim(),
          "date": DateTime.now().toIso8601String(),
        });
        formKey.currentState!.reset();
        contenidoCtrl.clear();
        return true;
      } catch (e) {
        debugPrint("Error al guardar recordatorio: $e");
        return false;
      }
    }
    return false;
  }
}
