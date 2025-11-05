/// Clase que centraliza los endpoints de la API de la aplicación.
///
/// Contiene rutas de acceso a los distintos recursos del backend, tanto
/// de **autenticación**, **perfil**, **tratamientos**, **pagos** y otros
/// servicios.
///
/// Uso típico:
/// ```dart
/// final url = "${Endpoints.baseUrl}${Endpoints.login}";
class Endpoints {
  // ---------------- BASE URL ----------------

  /// URL base para la API
  ///
  static const String baseUrl = "http://localhost:3000/"; //desarrollo

  // ---------------- AUTH ----------------

  /// Endpoint para registrar un nuevo usuario.
  static const String register = "register/";

  /// Endpoint para iniciar sesión.
  static const String login = "login/";

  /// Endpoint para obtener el perfil del usuario autenticado.
  static const String profile = "my_profile/";

  /// Endpoint para acceso versión 1
  static const String access = "access/";
}
