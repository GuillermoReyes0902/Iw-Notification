import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/models/notification_model.dart';
import '../providers/notification_provider.dart';
import 'package:win_toast/win_toast.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationRepo = Provider.of<NotificationRepository>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final notifications = notificationProvider.notifications;
    final scrollController = ScrollController();

    
    WinToast.instance().setActivatedCallback((event) {
      final notification = notificationRepo.processNotificationEvent(event);
      if (notification != null) {
        notificationProvider.addNotification(notification);
        _showDebugDialog(context, notification);
      }
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: notificationRepo.sendNotificationWithReply,
            child: const Text('Botón con contestación'),
          ),
          TextButton(
            onPressed: notificationRepo.sendSimpleNotification,
            child: const Text('Botón sin contestación'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Respuestas recibidas:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            width: 300,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: notifications.isEmpty
                ? const Center(
                    child: Text(
                      'No hay respuestas aún',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final reply = notifications[index].reply;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          'Respuesta ${index + 1}: $reply',
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showDebugDialog(BuildContext context, NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Respuesta detectada'),
        content: Text('Respuesta: ${notification.reply}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}