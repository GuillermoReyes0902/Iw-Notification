import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iwproject/firebase_options.dart';
import 'package:iwproject/presentation/pages/splash_screen.dart';
import 'package:iwproject/utils/local_notification_service.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/notification_provider.dart';
import 'package:launch_at_startup/launch_at_startup.dart';

/// BACKGROUND / TERMINATED HANDLER
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("BG MESSAGE: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inicializar Firebase SIEMPRE antes de usar cualquier plugin de Firebase
  if (Platform.isIOS || Platform.isAndroid || Platform.isMacOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    //Inicializar notificaciones locales
    await LocalNotificationService.init();

    //BACKGROUND
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// FOREGROUND
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("FG MESSAGE: ${message.messageId}");
      print("DATA: ${message.data}");
      if (message.notification != null) {
        print("NOTIF TITLE: ${message.notification!.title}");
        print("NOTIF BODY: ${message.notification!.body}");
      }
      LocalNotificationService.show(message);
    });

    /// USER TAP → APP EN FOREGROUND O BACKGROUND
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("USER TAPPED NOTIF");
      print("DATA: ${message.data}");
    });

    // 2. Ahora sí: APNS token (solo después de initializeApp)
    if (Platform.isIOS || Platform.isMacOS) {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      print(apnsToken);
    }

    /// USER TAPP EN ESTADO TERMINATED
    //_checkInitialMessage();
  }
  if (Platform.isMacOS || Platform.isWindows) {
    await _launchAtStartupInit();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        //ChangeNotifierProvider(create: (_) => ReminderListenerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

_launchAtStartupInit() async {
  launchAtStartup.setup(
    appName: "com.iwlabs.reminder",
    appPath: Platform.resolvedExecutable,
    // Set packageName parameter to support MSIX.
    packageName: 'com.iwlabs.reminder',
  );
  await launchAtStartup.enable();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
