import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Clase que centraliza valores constantes y utilidades comunes de la aplicación.
///
/// Contiene:
/// - **Cadenas y rutas** (archivos, URLs).
/// - **Claves de almacenamiento local** (SharedPreferences).
/// - **Headers y tokens** de red.
/// - **Códigos de estado HTTP**.
/// - **Formatos de fecha y hora**.
/// - **Máscaras de texto** para inputs.
/// - **Expresiones regulares** de validación.
/// - **Método para evaluar errores de red**.
///
/// Esta clase evita el uso de strings o valores "mágicos" dispersos en el código.
class ConstantData {
  // ---------------- STRINGS ----------------

  /// Error por falla de conexión (ClientException con SocketException).
  static const String conectionError = "ClientException with SocketException";

  // ---------------- SHARED PREFERENCES ----------------

  /// Token de autenticación del usuario.
  static const String userToken = 'USER_TOKEN';

  /// Identificador único del usuario.
  static const String userID = 'USER_ID';

  // ---------------- NETWORK HANDLER ----------------

  /// Claves usadas para autenticación con token Bearer.
  static const List<String> bearerToken = ['Authorization', 'Bearer'];

  /// Headers adicionales por defecto en peticiones HTTP.
  static const Map<String, String> additionalHeaders = {
    'Content-type': 'application/json; charset=utf-8',
    'Accept': 'application/json',
  };

  // ---------------- STATUS CODES ----------------

  /// Código HTTP de éxito.
  static const int success = 200;

  /// Código HTTP de error interno.
  static const int internalError = 500;

  /// Código HTTP de conflicto.
  static const int conflictError = 409;

  /// Código HTTP de error por falta de autorización.
  static const int unauthorizedError = 401;

  /// Código HTTP de error por permisos insuficientes.
  static const int unauthorizedError2 = 403;

  // ---------------- FUENTES ----------------

  // ---------------- FORMATOS DE FECHA/HORA ----------------

  // ---------------- LINKS ----------------

  // ---------------- MÉTODOS ----------------
  static DateFormat dateFormat = DateFormat('dd/MM/yyyy\nhh:mm');
  static DateFormat onlyDateFormat = DateFormat('dd/MM/yy');
  static DateFormat dateGridFormat = DateFormat('dd/MM');
  static const String defaultUserImage =
      'https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1095249842.jpg';

  //COLECCIONES
  //static const String reminderCollection = "reminders";
  static const String reminderCollection = "reminders_dev";
  static const String userCollection = "users";
  static const String projectCollection = "projects";

  //ATRIBUTOS REMINDER
  static const String reminderId = "id";
  static const String reminderDate = "date";
  static const String reminderDeadline = "deadline";
  static const String reminderPriority = "priority";
  static const String reminderContent = "content";
  static const String reminderSenderId = "senderId";
  static const String reminderProjectId = "projectId";
  static const String reminderStatus = "status";
  static const String reminderReceiverId = "receiverId";
  static const String reminderReceiversIds = "receiversIds";
  static const String reminderCompleted = "completed";

  //ATRIBUTOS USER
  static const String userId = "id";
  static const String userName = "name";
  static const String userPhoto = "photo";
  static const String fcmTokens = "fcmTokens";

  //ATRIBUTOS PROYECTO
  static const String projectId = "id";
  static const String projectName = "name";

  static const String addProjectId = '__add_project__';
  static const String allProjectsId = '__all_projects__';

  static Color getStatusColor(String status) {
    switch (status) {
      case 'completado':
        return Colors.green;
      case 'en_curso':
        return Colors.orange;
      case 'pendiente':
      default:
        return Colors.red;
    }
  }
}

// ---------------- ENUM ----------------
