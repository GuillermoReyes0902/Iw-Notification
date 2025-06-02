import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;
import 'presentation/pages/main_page.dart';
import 'presentation/providers/notification_provider.dart';
import 'utils/local_notification_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final logPath = p.join(dir.path, 'log');
  debugPrint('logPath: $logPath');

  await LocalNotificationHandler.initializationSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MainPage());
  }
}
