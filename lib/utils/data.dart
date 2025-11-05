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

  // ---------------- ENUM MAP ----------------

  // ---------------- MÉTODOS ----------------
}
