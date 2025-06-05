import 'package:flutter/material.dart';
import '../../domain/models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  final List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  void addNotification(NotificationModel notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController emisorCtrl = TextEditingController();
  TextEditingController contenidoCtrl = TextEditingController();
}
