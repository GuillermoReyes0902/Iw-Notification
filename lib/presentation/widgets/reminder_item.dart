import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iwproject/domain/models/reminder_model.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:provider/provider.dart';

class ReminderItem extends StatelessWidget {
  const ReminderItem({
    super.key,
    required this.reminder,
    required this.isLastReminder,
  });

  final ReminderModel reminder;
  final bool isLastReminder;

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final other = DateTime(date.year, date.month, date.day);
    final diffDays = today.difference(other).inDays;

    if (diffDays == 0) return 'Hoy';
    if (diffDays == 1) return 'Ayer';
    if (diffDays < 30) return 'Hace $diffDays días';
    if (diffDays < 365) return 'Hace ${(diffDays / 30).floor()} meses';
    return 'Hace ${(diffDays / 365).floor()} años';
  }

  Future<void> markAsCompleted(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('reminders')
          .doc(reminder.id)
          .update({'completed': !reminder.completed});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ENCABEZADO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Consumer<NotificationProvider>(
                        builder: (context, controller, _) {
                          final sender = controller.users.firstWhere((user) => user.id == reminder.senderId);
                          final receiver = controller.users.firstWhere((user) => user.id == reminder.receiverId);

                          return Text(
                            "De: ${sender.name}\nPara: ${receiver.name}",
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                          );
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            formatDate(reminder.date),
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        "\n${DateFormat('dd/MM/yyyy\nhh:mm').format(reminder.date)}",
                        textAlign: TextAlign.end,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // CONTENIDO
              Text(
                reminder.content,
                style: TextStyle(
                  color: reminder.completed ? Colors.grey : Colors.black87,
                  decoration: reminder.completed ? TextDecoration.lineThrough : null,
                ),
              ),

              // BOTÓN
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => markAsCompleted(context),
                  icon: Icon(reminder.completed ? Icons.check_circle : Icons.radio_button_unchecked, size: 18),
                  label: Text(reminder.completed ? "Completado" : "Marcar como completado"),
                  style: TextButton.styleFrom(
                    foregroundColor: reminder.completed ? Colors.green : Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),

        if (isLastReminder)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
      ],
    );
  }
}
