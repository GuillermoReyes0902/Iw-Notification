import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/reminder_model.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/utils/shared_preferences_handler.dart';
import 'package:iwproject/utils/text_data.dart';

class NotificationProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController contenidoCtrl = TextEditingController();
  final TextEditingController deadlineCtrl = TextEditingController(
    text: ConstantData.onlyDateFormat.format(DateTime.now()),
  );

  UserModel? currentUser;

  List<UserModel> users = [];
  String? editingReminderId;
  bool isLoading = false;

  UserModel? selectedSender;
  UserModel? selectedReceiver;
  UserModel? selectedReceiverMainList;

  List<UserModel> selectedReceivers = [];
  List<UserModel> selectedReceiversMainList = [];

  String? priority;

  void setPriority(String selectedPriority) {
    priority = selectedPriority;
    notifyListeners();
  }

  void setDeadline(DateTime selectedDate) {
    deadlineCtrl.text = ConstantData.onlyDateFormat.format(selectedDate);
    notifyListeners();
  }

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

  void setReceiver(UserModel? user) {
    selectedReceiver = user;
    notifyListeners();
  }

  void setMainListReceiver(UserModel? user) {
    selectedReceiverMainList = user;
    notifyListeners();
  }

  void setReceivers(List<UserModel> userList) {
    selectedReceivers = userList;
    notifyListeners();
  }

  void setMainListReceivers(List<UserModel> userList) {
    selectedReceiversMainList = userList;
    notifyListeners();
  }

  Future<bool> saveReminder() async {
    if (!formKey.currentState!.validate()) return false;

    isLoading = true;
    notifyListeners();

    try {
      final remindersRef = FirebaseFirestore.instance.collection(
        ConstantData.reminderCollection,
      );

      DateTime finalDate = DateTime.now();
      if (editingReminderId != null) {
        final snapshot = await remindersRef.doc(editingReminderId).get();
        if (snapshot.exists && snapshot.data()?['date'] != null) {
          final rawDate = snapshot.data()!['date'];
          if (rawDate is Timestamp) {
            finalDate = rawDate.toDate();
          } else if (rawDate is String) {
            finalDate = DateTime.tryParse(rawDate) ?? DateTime.now();
          }
        }
      }

      final reminderData = ReminderModel(
        date: finalDate,
        deadline: ConstantData.onlyDateFormat.parse(deadlineCtrl.text),
        priority: priority!,
        content: contenidoCtrl.text.trim(),
        senderId: selectedSender!.id,
        receiverId: selectedReceiver?.id,
        receiversIds: selectedReceivers.map((u) => u.id).toList(),
        completed: false,
        stateVersion: 'v2',
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
    deadlineCtrl.text = ConstantData.onlyDateFormat.format(reminder.deadline);
    priority = reminder.priority;

    try {
      selectedSender = users.firstWhere((u) => u.id == reminder.senderId);

      if (reminder.receiverId != null) {
        selectedReceiver = users.firstWhere(
          (u) => u.id == reminder.receiverId,
          orElse: () => users.first,
        );
      }

      final receivers = users
          .where((u) => reminder.receiversIds?.contains(u.id) ?? false)
          .toList();
      selectedReceivers = receivers;

      if (receivers.isNotEmpty) {
        selectedReceiversMainList = receivers;
      } else if (reminder.receiverId != null) {
        final fallbackUser = users.firstWhere(
          (u) => u.id == reminder.receiverId,
          orElse: () => users.first,
        );
        selectedReceiversMainList = [fallbackUser];
      }
    } catch (e) {
      debugPrint("Error al encontrar usuarios para edición: $e");
    }

    notifyListeners();
  }

  void clearForm() {
    contenidoCtrl.clear();
    selectedReceiver = null;
    selectedReceivers = [];
    editingReminderId = null;
    deadlineCtrl.text = ConstantData.onlyDateFormat.format(DateTime.now());
    priority = null;
    notifyListeners();
  }

  Future<void> toggleReminderCompletion(
    String reminderId,
    bool currentStatus,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection(ConstantData.reminderCollection)
          .doc(reminderId)
          .update({'completed': !currentStatus});
    } catch (e) {
      debugPrint("Error al actualizar estado: $e");
      rethrow;
    }
  }

  List<ReminderModel> filterRemindersByUser(
    List<ReminderModel> allReminders,
    UserModel? user,
  ) {
    if (user == null) return [];

    return allReminders.where((r) {
      final matchSingle = r.receiverId == user.id;
      final matchMultiple = r.receiversIds?.contains(user.id) ?? false;
      return matchSingle || matchMultiple;
    }).toList();
  }
}
