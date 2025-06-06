import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iwproject/domain/models/notification_model.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:iwproject/utils/local_notification_handler.dart';
import 'package:provider/provider.dart';
import 'package:iwproject/presentation/pages/view_test.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((NotificationResponse? response) {
      if (response != null) {
        final provider = context.read<NotificationProvider>();
        provider.addNotification(
          NotificationModel(
            id: '${response.id}',
            payload: '${response.payload}',
            actionID: '${response.actionId}',
            reply: '${response.input}',
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _configureSelectNotificationSubject();
  }

  @override
  void dispose() {
    selectNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => LocalNotificationHandler.showNotification("Body simple"),
              child: const Text("Notificación simple"),
            ),
            TextButton(
              onPressed:
                  LocalNotificationHandler.showNotificationWithPlainAction,
              child: const Text("Notificación con acciones"),
            ),
            TextButton(
              onPressed:
                  LocalNotificationHandler.showNotificationWithTextAction,
              child: const Text("Notificación con texto"),
            ),
            TextButton(
              onPressed: LocalNotificationHandler.cancelNotification,
              child: const Text("Cancelar última notificación"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MessageSenderScreen()),
                );
              },
              child: const Text("Navegar"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: const Text(
                'Respuestas:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Consumer<NotificationProvider>(
              builder: (_, provider, __) {
                return provider.notifications.isEmpty
                    ? Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'No hay respuestas aún',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: provider.notifications.length,
                          padding: EdgeInsets.all(10),
                          itemBuilder: (_, index) {
                            final item = provider.notifications[index];
                            return Card(
                              child: ListTile(
                                title: Text(
                                  "ID: ${item.id}\nPAYLOAD: ${item.payload}",
                                ),
                                subtitle: Text("ACTION ID: ${item.actionID}\n REPLY: ${item.reply}"),
                              ),
                            );
                          },
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
