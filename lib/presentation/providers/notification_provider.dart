import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iwproject/utils/local_notification_handler.dart';

class NotificationProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  TextEditingController emisorCtrl = TextEditingController();
  TextEditingController contenidoCtrl = TextEditingController();

  Future<bool> saveReminder() async {
    if (formKey.currentState!.validate()) {
      DatabaseReference reference = FirebaseDatabase.instance
          .ref()
          .child('reminders')
          .push(); // Genera una clave única
      await reference.set({
        "name": emisorCtrl.text.trim(),
        "content": contenidoCtrl.text.trim(),
        "date": DateFormat('dd/MM/yyyy').format(DateTime.now()),
      });
      await LocalNotificationHandler.showNotification(
        emisorCtrl.text.trim(),
        contenidoCtrl.text.trim(),
      );
      formKey.currentState!.reset();
      return true;
    }
    return false;
  }
}
