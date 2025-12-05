import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/project_model.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/firebase_options.dart';
import 'package:iwproject/presentation/pages/notification_list_screen.dart';
import 'package:iwproject/presentation/pages/user_login_screen.dart';
import 'package:iwproject/utils/data.dart';
import 'package:iwproject/utils/local_notification_service.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/notification_provider.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
//import 'package:iwproject/presentation/providers/reminder_listener_provider.dart';

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

    if (!Platform.isMacOS) {
      await LocalNotificationService.init();
    }

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
    if (Platform.isIOS) {
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
  void initState() {
    //Cargar usuarios desde Firestore
    final users = FirebaseFirestore.instance.collection(
      ConstantData.userCollection,
    );
    final controller = context.read<NotificationProvider>();

    users.get().then((querySnapshot) async {
      final users = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return UserModel.fromJson({ConstantData.userId: doc.id, ...data});
      }).toList();
      await controller.setUsers(users);
      await controller.getUser();
    });

    //Cargar proyectos desde Firestore
    final projects = FirebaseFirestore.instance.collection(
      ConstantData.projectCollection,
    );

    projects.get().then((querySnapshot) {
      final projects = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return ProjectModel.fromJson({ConstantData.projectId: doc.id, ...data});
      }).toList();
      controller.setProjects(projects);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Selector<NotificationProvider, UserModel?>(
        selector: (_, controller) => controller.currentUser,
        builder: (_, currentUser, _) {
          return currentUser != null
              ? NotificationListScreen()
              : UserLoginScreen();
        },
      ),
    );
  }
}
