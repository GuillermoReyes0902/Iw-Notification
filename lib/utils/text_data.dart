import 'package:flutter/material.dart';

class TextData {
  static const String messageListTitle = "Recordatorios recibidos";
  static const List<String> messageListSubtitle = ["Hay ", " recordatorios"];
  static const String empptyReminders =
      "No hay recordatorios para el usuario seleccionado";
  static const String all = "Todos";
  static const String sender = "De: ";
  static const String receiver = "Para: ";
  static const String project = "Proyecto: ";
  static const String addProjectOption = "Agregar nuevo proyecto";
  static const String newProjectDialogTitle = "Nuevo proyecto";
  static const String newProjectFieldHint = "Nombre del proyecto";
  static const String newProjectValidator = "Nombre del proyecto vacío";
  static const String newProjectCreated = "Proyecto creado";
  static const String newProjectError = "No se pudo crear el proyecto";
  static const String dialogCancel = "Cancelar";
  static const String dialogSave = "Guardar";

  static const List<String> timeAgo = [
    "Hoy",
    "Ayer",
    "Hace ",
    " días",
    " meses",
    " años",
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
  static const String projectValidator = "Proyecto vacío";
  static const String priorityValidator = "Prioridad vacía";
  static const String deadline = "Fecha límite  ";
  static const String deadlineMobile = "Fecha\nlímite  ";
  static const String priority = "  Prioridad  ";
  static const List<String> priorityList = ["Baja", "Intermedia", "Alta"];
  static const String content = "Contenido del recordatorio";
  static const String contentHint = "Escribe el recordatorio aquí...";
  static const String contentValidator = "Contenido vacío";
  static const String sendReminderButton = "Enviar Recordatorio";
  static const String reminderListButton = "Ver recordatorios";

  static String loginTitle = "¿Quién está usando IW Reminder?";

  static const Map<String, Color> priorityColors = {
    "Baja": Colors.green,
    "Intermedia": Colors.orange,
    "Alta": Colors.red,
  };
}
