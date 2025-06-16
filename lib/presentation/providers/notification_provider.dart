import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/reminder_model.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/utils/shared_preferences_handler.dart';
import 'package:iwproject/utils/text_data.dart';

class NotificationProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController contenidoCtrl = TextEditingController();

  UserModel? currentUser;

  List<UserModel> users = [];
  String? editingReminderId;
  bool isLoading = false;

  UserModel? selectedSender;
  UserModel? selectedReceiver;
  UserModel? selectedReceiverMainList;

  Future<void> logIn(UserModel selectedUser) async {
    await SharedPreferencesHandler.setUser(selectedUser);
    currentUser = selectedUser;
    selectedSender = selectedUser;
    notifyListeners();
  }

  Future<void> logOut() async {
    await SharedPreferencesHandler.deleteUser();
    currentUser = null;
    selectedSender = null;
    notifyListeners();
  }

  Future<bool> getUser() async {
    final user = await SharedPreferencesHandler.getUser();
    if (user != null) {
      currentUser = user;
      selectedSender = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  void setUsers(List<UserModel> newUsers) {
    users = newUsers;
    notifyListeners();
  }

  void setSender(UserModel? user) {
    selectedSender = user;
    notifyListeners();
  }

  void setReceiver(UserModel? user) {
    selectedReceiver = user;
    notifyListeners();
  }

  void setMainListReceiver(UserModel? user) {
    selectedReceiverMainList = user;
    notifyListeners();
  }

  Future<bool> saveReminder() async {
    if (!formKey.currentState!.validate()) return false;
    if (selectedSender == null || selectedReceiver == null) return false;

    isLoading = true;
    notifyListeners();

    try {
      final remindersRef = FirebaseFirestore.instance
          .collection(ConstantData.reminderCollectionDev);

      final reminderData = ReminderModel(
        date: DateTime.now(),
        content: contenidoCtrl.text.trim(),
        senderId: selectedSender!.id,
        receiverId: selectedReceiver!.id,
        completed: false,
      ).toJson();

      if (editingReminderId != null) {
        await remindersRef.doc(editingReminderId).update(reminderData);
      } else {
        await remindersRef.add(reminderData);
      }

      clearForm();
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error al guardar recordatorio: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void setReminderDataForEditing(ReminderModel reminder) {
    editingReminderId = reminder.id;
    contenidoCtrl.text = reminder.content;

    try {
      selectedSender = users.firstWhere((u) => u.id == reminder.senderId);
      selectedReceiver = users.firstWhere((u) => u.id == reminder.receiverId);
    } catch (e) {
      debugPrint("Error al encontrar usuarios para edición: $e");
    }

    notifyListeners();
  }

  void clearForm() {
    contenidoCtrl.clear();
    selectedSender = currentUser; 
    selectedReceiver = null;
    editingReminderId = null;
    notifyListeners();
  }

  Future<void> toggleReminderCompletion(String reminderId, bool currentStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection(ConstantData.reminderCollectionDev)
          .doc(reminderId)
          .update({'completed': !currentStatus});
    } catch (e) {
      debugPrint("Error al actualizar estado: $e");
      rethrow;
    }
  }
}
