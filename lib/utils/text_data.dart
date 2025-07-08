import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TextData {
  static const String messageListTitle = "Recordatorios recibidos";
  static const List<String> messageListSubtitle = ["Hay ", " recordatorios"];
  static const String empptyReminders =
      "No hay recordatorios para el usuario seleccionado";
  static const String all = "Todos";
  static const String sender = "De: ";
  static const String receiver = "Para: ";

  static const List<String> timeAgo = [
    "Hoy",
    "Ayer",
    "Hace ",
    " días",
    "meses",
    "años",
  ];

  static const Map<String, String> statusOptions = {
    'completado': "Completado",
    'en_curso': "En curso",
    'pendiente': "Pendiente",
  };

  static const String newReminderButton = "Nuevo Recordatorio";
  static const String logOutButton = "Cerrar sesión";

  static const String messageSenderTitle = "Enviar nuevo recordatorio";
  static const String messageSenderSubtitle =
      "Completa los campos del recordatorio";
  static const String selectSender = "Seleccionar remitente";
  static const String senderValidator = "Remitente vacío";
  static const String selectReciver = "Seleccionar destinatario";
  static const String receiverValidator = "Destinatario vacío";
  static const String priorityValidator = "Prioridad vacía";
  static const String deadline = "Fecha límite  ";
  static const String priority = "  Prioridad  ";
  static const List<String> priorityList = ["Baja", "Intermedia", "Alta"];
  static const String content = "Contenido del recordatorio";
  static const String contentHint = "Escribe el recordatorio aquí...";
  static const String contentValidator = "Contenido vacío";
  static const String sendReminderButton = "Enviar Recordatorio";
  static const String reminderListButton = "Ver recordatorios";

  static String loginTitle = "¿Quién está usando IW Reminder?";

  static String getCompletedLabel(
    String? status,
    String? stateVersion,
    bool? isCompleted,
  ) {
    final version = stateVersion ?? 'v1';
    if (version == 'v2' && status != null) {
      return statusOptions[status]!;
    } else {
      if (isCompleted != null) {
        return isCompleted
            ? statusOptions['completado']!
            : statusOptions['pendiente']!;
      } else {
        return statusOptions['pendiente']!;
      }
    }
  }

  static const Map<String, Color> priorityColors = {
    "Baja": Colors.green,
    "Intermedia": Colors.orange,
    "Alta": Colors.red,
  };
}

class ConstantData {
  static DateFormat dateFormat = DateFormat('dd/MM/yyyy\nhh:mm');
  static DateFormat onlyDateFormat = DateFormat('dd/MM/yyyy');

  //static const String reminderCollection = "reminders";
  static const String reminderCollection = "reminders_dev";
  static const String reminderId = "id";
  static const String reminderDate = "date";
  static const String reminderDeadline = "deadline";
  static const String reminderPriority = "priority";
  static const String reminderContent = "content";
  static const String reminderSenderId = "senderId";
  static const String reminderReceiverId = "receiverId";
  static const String reminderReceiversIds = "receiversIds";
  static const String reminderCompleted = "completed";
  static const String userCollection = "users";
  static const String userId = "id";
  static const String userName = "name";
  static const String userPhoto = "photo";
  static const String defaultUserImage =
      'https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1095249842.jpg';
}
