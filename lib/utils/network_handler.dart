import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iwproject/utils/data.dart';
import 'package:iwproject/utils/endpoints.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HttpRequestType { post, get, put }

/// Clase que contiene métodos para el manejo del protocolo http
class NetworkHandler {
  static const int timeoutDuration = 30;

  // Método auxiliar para construir headers
  static Future<Map<String, String>> _buildHeaders(
    bool requiereAuth, [
    String? tokens,
  ]) async {
    final headers = {...ConstantData.additionalHeaders};

    if (requiereAuth) {
      headers.addAll(await _authToken(tokens: tokens));
    }

    return headers;
  }

  // Método auxiliar para manejar solicitudes HTTP
  static Future<http.Response> _sendRequest(
    HttpRequestType method,
    String url, {
    bool requiereAuth = true,
    dynamic body, //Map<String, dynamic>?
    String? tokens,
  }) async {
    String fullUrl = Endpoints.baseUrl + url;
    final headers = await _buildHeaders(requiereAuth, tokens);
    final uri = Uri.parse(fullUrl).replace(
      queryParameters: {
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );

    try {
      late http.Response? response;
      response = null;
      if (method == HttpRequestType.get) {
        body = body as Map<String, dynamic>;
        // ignore: unnecessary_null_comparison
        final queryString = body != null && body.isNotEmpty
            ? Uri(
                queryParameters: body.map((k, v) => MapEntry(k, v.toString())),
              ).query
            : '';
        response = await http
            .get(uri.replace(query: queryString), headers: headers)
            .timeout(const Duration(seconds: timeoutDuration));
      } else if (method == HttpRequestType.post) {
        response = await http
            .post(uri, headers: headers, body: jsonEncode(body ?? {}))
            .timeout(const Duration(seconds: timeoutDuration));
      } else if (method == HttpRequestType.put) {
        response = await http
            .put(uri, headers: headers, body: jsonEncode(body ?? {}))
            .timeout(const Duration(seconds: timeoutDuration));
      }
      Logger().i(
        "URL $fullUrl\nBODY $body\nHEADERS $headers\nSTATUS CODE ${response!.statusCode}\n ${response.body}",
      );
      return response;
    } catch (error) {
      Logger().e('Error during $method request to $fullUrl: $error');
      rethrow;
    }
  }

  // Método GET optimizado
  Future<http.Response> get({
    required String url,
    bool requiereAuth = true,
    Map<String, dynamic>? body = const {},
  }) {
    return _sendRequest(
      HttpRequestType.get,
      url,
      requiereAuth: requiereAuth,
      body: body,
    );
  }

  // Método POST optimizado
  static Future<http.Response> post({
    required String url,
    bool requiereAuth = true,
    dynamic body = const {}, //Map<String, dynamic>?
    String? tokens,
  }) {
    return _sendRequest(
      HttpRequestType.post,
      url,
      requiereAuth: requiereAuth,
      body: body,
      tokens: tokens,
    );
  }

  // Método PUT optimizado
  static Future<http.Response> put({
    required String url,
    bool requiereAuth = true,
    dynamic body = const {}, //Map<String, dynamic>?
    String? tokens,
  }) {
    return _sendRequest(
      HttpRequestType.put,
      url,
      requiereAuth: requiereAuth,
      body: body,
      tokens: tokens,
    );
  }

  // Método para obtener token de autenticación
  static Future<Map<String, String>> _authToken({String? tokens}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = tokens ?? prefs.getString(ConstantData.userToken);
    if (token == null) {
      throw Exception('Token not found');
    }
    return {
      ConstantData.bearerToken[0]: "${ConstantData.bearerToken[1]} $token",
    };
  }

  // /// MÉTODO PARA CONVERTIR URL A BASE64 Y GUARDAR EN LOCAL
  // static Future<String> networkImageToLocalStorage(String newURL) async {
  //   http.Response response = await http.get(Uri.parse(newURL));
  //   if (response.statusCode != 200) {
  //     throw Exception(
  //         "Error al obtener la imagen: ${response.statusCode}\n${response.body}");
  //   }
  //   Uint8List byte = response.bodyBytes;

  //   return ImagePickerHelper.saveLocalImage(byte, newURL.split("/").last);
  // }

  // Método POST para multipart
  // static Future<http.StreamedResponse> postMultipart({
  //   required String url,
  //   required bool requiereAuth,
  //   required PhotoModel photo,
  //   Map<String, String>? additionalFields,
  //   String? tokens,
  // }) async {
  //   String fullUrl = Endpoints.baseUrl + url;
  //   var headers = await _buildHeaders(requiereAuth, tokens);
  //   headers.remove('Content-type'); // Remover el encabezado Content-Type

  //   var uri = Uri.parse(fullUrl);
  //   var request = http.MultipartRequest('POST', uri);

  //   // Agregar headers a la solicitud
  //   request.headers.addAll(headers);

  //   // Agregar campos adicionales (si los hay)
  //   if (additionalFields != null) {
  //     request.fields.addAll(additionalFields);
  //   }

  //   // Procesar el archivo PhotoModel
  //   var file = photo.temporalFile;
  //   //var fileName = photo.name;

  //   // Verifica el tipo MIME
  //   var mimeType = lookupMimeType(file.path);

  //   // Crear un archivo multipart
  //   request.files.add(await http.MultipartFile.fromPath(
  //     'avatar', // Nombre del campo que recibirá el servidor
  //     file.path,
  //     // filename: fileName,
  //     contentType: mimeType != null ? MediaType.parse(mimeType) : null,
  //   ));

  //   // Enviar la solicitud y esperar la respuesta
  //   try {
  //     var streamedResponse = await request.send();
  //     Logger().i(
  //         "URL $fullUrl\nADDITIONAL FIELDS: $additionalFields\nMIME TYPE: $mimeType\nFILE PATH: ${file.path}\nHEADERS $headers\nSTATUS CODE ${streamedResponse.statusCode}\n ${streamedResponse.reasonPhrase}");
  //     return streamedResponse;
  //   } catch (error) {
  //     Logger().e('Error during request to $fullUrl: $error');
  //     rethrow;
  //   }
  // }
}
