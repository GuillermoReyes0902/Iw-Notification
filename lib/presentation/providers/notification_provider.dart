import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/reminder_model.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/utils/shared_preferences_handler.dart';
import 'package:iwproject/utils/text_data.dart';

class NotificationProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  TextEditingController contenidoCtrl = TextEditingController();

  UserModel? currentUser;

  void logIn(UserModel selectedUser) async {
    await SharedPreferencesHandler.setUser(selectedUser);
    currentUser = selectedUser;
    notifyListeners();
  }

  void logOut() async {
    await SharedPreferencesHandler.deleteUser();
    currentUser = null;
    notifyListeners();
  }

  Future<bool> getUser() async {
    var user = await SharedPreferencesHandler.getUser();
    if (user != null) {
      currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

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
          ConstantData.reminderCollectionDev,
        );
        await remindersRef.add(
          ReminderModel(
            date: DateTime.now(),
            content: contenidoCtrl.text.trim(),
            senderId: currentUser!.id,
            receiverId: selectedReceiver?.id ?? '',
            completed: false,
          ).toJson(),
        );
        formKey.currentState!.reset();
        contenidoCtrl.clear();
        selectedReceiver = null;
        notifyListeners();
        return true;
      } catch (e) {
        debugPrint("Error al guardar recordatorio: $e");
      }
    }
    return false;
  }

  UserModel? selectedReceiver;
  UserModel? selectedReceiverMainList;

  void setMainListReceiver(UserModel? user) {
    selectedReceiverMainList = user;
    notifyListeners();
  }

  void setReceiver(UserModel? user) {
    selectedReceiver = user;
    notifyListeners();
  }
}
