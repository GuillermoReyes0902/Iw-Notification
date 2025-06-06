import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final StreamController<NotificationResponse> selectNotificationStream =
    StreamController<NotificationResponse>.broadcast();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

int id = 0;

class LocalNotificationHandler {
  static List<DarwinNotificationCategory> darwinNotificationCategories = [
    DarwinNotificationCategory(
      'input_category',
      actions: [
        DarwinNotificationAction.text(
          'text_action_id_1',
          'Responder',
          buttonTitle: 'Enviar',
          placeholder: 'Escribe algo...',
        ),
      ],
    ),
    DarwinNotificationCategory(
      'plain_category',
      actions: [
        DarwinNotificationAction.plain('action_id_1', 'Acción 1'),
        DarwinNotificationAction.plain(
          'action_id_2',
          'Acción destructiva',
          options: {DarwinNotificationActionOption.destructive},
        ),
        DarwinNotificationAction.plain(
          'action_id_3',
          'Acción foreground',
          options: {DarwinNotificationActionOption.foreground},
        ),
      ],
      options: {DarwinNotificationCategoryOption.hiddenPreviewShowTitle},
    ),
  ];

  static Future<void> initializationSettings() async {
    InitializationSettings initializationSettings;

    if (Platform.isWindows) {
      const windowsSettings = WindowsInitializationSettings(
        appName: 'Max Dashboard',
        appUserModelId: 'com.max.dashboard',
        guid: '5ee60622-21da-4dd8-9c04-7010907c0985', // sin llaves
      );

      initializationSettings = const InitializationSettings(
        windows: windowsSettings,
      );
    } else if (Platform.isMacOS) {
      initializationSettings = InitializationSettings(
        macOS: DarwinInitializationSettings(
          notificationCategories: darwinNotificationCategories,
        ),
      );
    } else {
      initializationSettings = const InitializationSettings(); // Por si se ejecuta en otro OS
    }

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: selectNotificationStream.add,
      // TODO: Puedes agregar onDidReceiveBackgroundNotificationResponse aquí si lo usas
    );
  }

  static Future<void> showNotification() async {
    await flutterLocalNotificationsPlugin.show(
      id++,
      'Título simple',
      'Cuerpo simple',
      const NotificationDetails(),
      payload: 'simple_notification',
    );
  }

  static Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(--id);
  }

  static Future<void> showNotificationWithPlainAction() async {
    final details = NotificationDetails(
      macOS: DarwinNotificationDetails(categoryIdentifier: 'plain_category'),
    );
    await flutterLocalNotificationsPlugin.show(
      id++,
      'Título con acciones',
      'Cuerpo con acciones',
      details,
      payload: 'plain_action_notification',
    );
  }

  static Future<void> showNotificationWithTextAction() async {
    final details = NotificationDetails(
      macOS: DarwinNotificationDetails(categoryIdentifier: 'input_category'),
    );
    await flutterLocalNotificationsPlugin.show(
      id++,
      'Título con texto',
      'Cuerpo con texto',
      details,
      payload: 'text_action_notification',
    );
  }
}
