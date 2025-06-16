import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/firebase_options.dart';
import 'package:iwproject/presentation/pages/notification_list_screen.dart';
import 'package:iwproject/presentation/providers/reminder_listener_provider.dart';
import 'package:iwproject/utils/text_data.dart';
//import 'package:iwproject/presentation/providers/reminder_listener_provider.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/notification_provider.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'utils/local_notification_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseDatabase.instanceFor(
    app: app,
    databaseURL: DefaultFirebaseOptions.currentPlatform.databaseURL!,
  );

  //await LocalNotificationHandler.initializationSettings();

  if (kIsWeb) {
    // Lógica para web
    //_fcmInit();
  } else {
    if (!Platform.isWindows) {
      //Inicializa FCM en todas las plataformas que no sean windows
      //_fcmInit();
    }
    if (Platform.isMacOS) {
      //Solo para macOS
      _launchAtStartupInit();
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ReminderListenerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// _fcmInit() async {
//   await FirebaseMessaging.instance.requestPermission();
//   String? token = await FirebaseMessaging.instance.getToken();
//   print('🔑 Token FCM: $token');
// }

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
    final users = FirebaseFirestore.instance.collection(
      ConstantData.userCollection,
    );
    final controller = context.read<NotificationProvider>();

    users.get().then((querySnapshot) {
      final users = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return UserModel.fromJson({ConstantData.userId: doc.id, ...data});
      }).toList();

      controller.setUsers(users);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationListScreen(),
    );
  }
}
