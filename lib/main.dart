import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/firebase_options.dart';
import 'package:iwproject/presentation/pages/notification_list_screen.dart';
import 'package:iwproject/presentation/pages/user_login_screen.dart';
import 'package:iwproject/utils/text_data.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/notification_provider.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
//import 'package:iwproject/presentation/providers/reminder_listener_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (Platform.isMacOS) {
    _launchAtStartupInit();
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
      controller.getUser();
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
