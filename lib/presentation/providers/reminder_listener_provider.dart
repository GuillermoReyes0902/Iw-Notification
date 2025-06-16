import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/reminder_model.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:iwproject/utils/local_notification_handler.dart';
import 'package:iwproject/utils/text_data.dart';
import 'package:provider/provider.dart';

class ReminderListenerProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot>? _subscription;

  List<String> initialReminders = [];

  void setInitialReminders(List<ReminderModel> reminders) {
    if (initialReminders.isEmpty) {
      for (var reminder in reminders) {
        initialReminders.add(reminder.id!);
      }
    }
  }

  void addReminderToInitialList(String reminderId) {
    //doble verificación
    if (!initialReminders.contains(reminderId)) {
      initialReminders.add(reminderId);
    }
  }

  void startListening(BuildContext context) async {
    _subscription?.cancel(); // detener si ya está escuchando
    _subscription = _db
        .collection(ConstantData.reminderCollectionDev)
        .snapshots()
        .listen((snapshot) async {
          if (snapshot.docChanges.any(
            (c) => c.type == DocumentChangeType.added,
          )) {
            for (var doc in snapshot.docs) {
              //filtrar el documento nuevo
              if (initialReminders.isNotEmpty &&
                  !initialReminders.contains(doc.id)) {
                debugPrint(doc.data()[ConstantData.reminderContent]);
                //TODO: filtrar para solo mostrar las notificaciones que tengan
                // receiverId == con el usuario iniciado sesión
                //búsqueda de nombres
                if (!context.mounted) return;
                final controller = context.read<NotificationProvider>();
                final sender = controller.users.firstWhere(
                  (user) =>
                      user.id == doc.data()[ConstantData.reminderSenderId],
                );
                final receiver = controller.users.firstWhere(
                  (user) =>
                      user.id == doc.data()[ConstantData.reminderReceiverId],
                );
                //enviar notificación
                await LocalNotificationHandler.showNotification(
                  "Nuevo recordatorio de ${sender.name} para ${receiver.name}",
                  "",
                );
                //agregarlo a reminders iniciales
                addReminderToInitialList(doc.id);
              }
            }
          }
        });
  }

  void stopListening() {
    _subscription?.cancel();
  }

  void disposeListener() {
    stopListening();
  }
}
