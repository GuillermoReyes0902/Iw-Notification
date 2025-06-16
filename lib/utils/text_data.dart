import 'package:intl/intl.dart';

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
  static const List<String> completedState = ["Completado", "Pendiente"];
  static const String newReminderButton = "Nuevo Recordatorio";
  //
  static const String messageSenderTitle = "Enviar nuevo recordatorio";
  static const String messageSenderSubtitle =
      "Completa los campos del recordatorio";
  static const String selectSender = "Seleccionar remitente";
  static const String senderValidator = "Remitente vacío";
  static const String selectReciver = "Seleccionar destinatario";
  static const String receiverValidator = "Destinatario vacío";
  static const String content = "Contenido del recordatorio";
  static const String contentHint = "Escribe el recordatorio aquí...";
  static const String contentValidator = "Contenido vacío";
  static const String sendReminderButton = "Enviar Recordatorio";
  static const String reminderListButton = "Ver recordatorios";
}

class ConstantData {
  static DateFormat dateFormat = DateFormat('dd/MM/yyyy\nhh:mm');
  //
  //static const String reminderCollection = "reminders";
  static const String reminderCollectionDev = "reminders_dev";
  static const String reminderId = "id";
  static const String reminderDate = "date";
  static const String reminderContent = "content";
  static const String reminderSenderId = "senderId";
  static const String reminderReceiverId = "receiverId";
  static const String reminderCompleted = "completed";
  //
  static const String userCollection = "users";
  static const String userId = "id";
  static const String userName = "name";
}
