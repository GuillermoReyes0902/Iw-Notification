import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/project_model.dart';
import 'package:iwproject/domain/models/reminder_model.dart';
//import 'package:iwproject/domain/models/request/access_request.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/utils/data.dart';
// import 'package:iwproject/utils/endpoints.dart';
// import 'package:iwproject/utils/network_handler.dart';
import 'package:iwproject/utils/shared_preferences_handler.dart';

class NotificationProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController contenidoCtrl = TextEditingController();
  final TextEditingController deadlineCtrl = TextEditingController(
    text: ConstantData.onlyDateFormat.format(DateTime.now()),
  );

  UserModel? currentUser;
  //bool isVersion2 = true;

  List<UserModel> users = [];
  List<ProjectModel> projects = [];
  String? editingReminderId;
  bool isLoading = false;
  String? priority;

  //dropdowns proyecto
  ProjectModel? selectedProject;
  ProjectModel? selectedProjectMainList;

  ///dropdowns receptor
  UserModel? selectedReceiverMainList;
  List<UserModel> selectedReceivers = [];

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
    await firebaseVerification();
    notifyListeners();
  }

  Future<void> logOut() async {
    await SharedPreferencesHandler.deleteUser();
    currentUser = null;
    notifyListeners();
  }

  Future<bool> firebaseVerification() async {
    if (Platform.isIOS || Platform.isAndroid || Platform.isMacOS) {
      print("- - - - - here");
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      await firebaseMessaging.requestPermission();
      final fCMToken = await firebaseMessaging.getToken();
      print('Token: $fCMToken');
      if (fCMToken != null) {
        print('Before FCM Tokens:; ${currentUser!.fcmTokens}');
        if (!currentUser!.fcmTokens.contains(fCMToken)) {
          currentUser!.fcmTokens.add(fCMToken);
          //actualizo remoto
          await FirebaseFirestore.instance
              .collection(ConstantData.userCollection)
              .doc(currentUser!.id)
              .update({ConstantData.fcmTokens: currentUser!.fcmTokens});
          //actualizo local
          await SharedPreferencesHandler.updateUser(currentUser!);
          print('After FCM Tokens: ${currentUser!.fcmTokens}');
        }
      }
    }
    return true;
  }

  Future<bool> getUser() async {
    final user = await SharedPreferencesHandler.getUser();
    if (user != null) {
      currentUser = user;
      await firebaseVerification();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> setUsers(List<UserModel> newUsers) async {
    users = newUsers;
    notifyListeners();
    return;
  }

  void setProjects(List<ProjectModel> newProjects) {
    projects = newProjects;
    notifyListeners();
  }

  Future<ProjectModel?> addProject(String projectName) async {
    final trimmedName = projectName.trim();
    if (trimmedName.isEmpty) return null;

    try {
      final doc = await FirebaseFirestore.instance
          .collection(ConstantData.projectCollection)
          .add({ConstantData.projectName: trimmedName});

      final project = ProjectModel(id: doc.id, name: trimmedName);
      projects = [...projects, project];
      selectedProject = project;
      notifyListeners();
      return project;
    } catch (e) {
      debugPrint("Error al agregar proyecto: $e");
      return null;
    }
  }

  void setProject(ProjectModel? project) {
    selectedProject = project;
    notifyListeners();
  }

  void setMainListProject(ProjectModel? project) {
    selectedProjectMainList = project;
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
        senderId: currentUser!.id,
        projectId: selectedProject!.id,
        receiverId: selectedReceivers.first.id, //NEW
        receiversIds: selectedReceivers.map((u) => u.id).toList(),
        completed: false,
        status: 'pendiente',
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
    selectedProject = projects.firstWhere((p) => p.id == reminder.projectId);
    selectedReceivers = users
        .where((u) => reminder.receiversIds.contains(u.id))
        .toList();

    notifyListeners();
  }

  void clearForm() {
    contenidoCtrl.clear();
    selectedReceivers = [];
    selectedReceiverMainList = null;
    selectedProject = null;
    selectedProjectMainList = null;

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
      final matchMultiple = r.receiversIds.contains(user.id);
      return matchSingle || matchMultiple;
    }).toList();
  }
}
