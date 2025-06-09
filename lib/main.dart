import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iwproject/firebase_options.dart';
import 'package:iwproject/presentation/pages/message_sender_screen.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
//import 'package:path/path.dart' as p;
//import 'presentation/pages/main_page.dart';
import 'presentation/providers/notification_provider.dart';
import 'utils/local_notification_handler.dart';
import 'package:launch_at_startup/launch_at_startup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final dir = await getApplicationDocumentsDirectory();
  // final logPath = p.join(dir.path, 'log');
  // debugPrint('logPath: $logPath');

  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseDatabase.instanceFor(
    app: app,
    databaseURL: DefaultFirebaseOptions.currentPlatform.databaseURL!,
  );

  await LocalNotificationHandler.initializationSettings();

  if (kIsWeb) {
    // Lógica para web
    _fcmInit();
  } else {
    if (Platform.isMacOS) {
      _fcmInit();
      _launchAtStartupInit();
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

_fcmInit() async {
  await FirebaseMessaging.instance.requestPermission();
  String? token = await FirebaseMessaging.instance.getToken();
  print('🔑 Token FCM: $token');
}

_launchAtStartupInit() async {
  launchAtStartup.setup(
    appName: "com.iwlabs.reminder",
    appPath: Platform.resolvedExecutable,
    // Set packageName parameter to support MSIX.
    packageName: 'com.iwlabs.reminder',
  );
  await launchAtStartup.enable();
  print(await launchAtStartup.isEnabled());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MessageSenderScreen());
  }
}
