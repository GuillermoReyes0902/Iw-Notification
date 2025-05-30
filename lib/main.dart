// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mixin_logger/mixin_logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'domain/repositories/notification_repository.dart';
import 'presentation/providers/notification_provider.dart';
import 'presentation/pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicialización de logger
  final dir = await getApplicationDocumentsDirectory();
  final logPath = p.join(dir.path, 'log');
  initLogger(logPath);
  i('logPath: $logPath');

  // Inicialización de WinToast
  final notificationRepo = NotificationRepository();
  final initialized = await notificationRepo.initializeWinToast();
  assert(initialized);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        Provider(create: (_) => notificationRepo),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Notificaciones IW')),
        body: const MainPage(),
      ),
    );
  }
}