import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/reminder_model.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/utils/text_data.dart';

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
        final remindersRef = FirebaseFirestore.instance.collection(
          ConstantData.reminderCollection,
        );
        await remindersRef.add(
          ReminderModel(
            date: DateTime.now(),
            content: contenidoCtrl.text.trim(),
            senderId: selectedSender?.id ?? '',
            receiverId: selectedReceiver?.id ?? '',
            completed: false,
          ).toJson(),
        );
        formKey.currentState!.reset();
        contenidoCtrl.clear();
        selectedSender = null;
        selectedReceiver = null;
        notifyListeners();
        return true;
      } catch (e) {
        debugPrint("Error al guardar recordatorio: $e");
        return false;
      }
    }
    return false;
  }

  UserModel? selectedSender;
  UserModel? selectedReceiver;
  UserModel? selectedReceiverMainList;

  void setSender(UserModel? user) {
    selectedSender = user;
    notifyListeners();
  }

  void setMainListReceiver(UserModel? user) {
    selectedReceiverMainList = user;
    notifyListeners();
  }

  void setReceiver(UserModel? user) {
    selectedReceiver = user;
    notifyListeners();
  }
}
