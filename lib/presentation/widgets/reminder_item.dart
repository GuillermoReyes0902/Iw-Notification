import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iwproject/domain/models/reminder_model.dart';

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
    final diff = now.difference(date);
    //TODO, TEMPORAL MIENTRAS AÑADIMOS HORA A "date"
    if (diff.inDays < 1) {
      return 'Hoy';
    }
    //
    if (diff.inMinutes < 60) {
      return 'Hace ${diff.inMinutes} ${diff.inMinutes == 1 ? "minuto" : "minutos"}';
    } else if (diff.inHours < 24) {
      return 'Hace ${diff.inHours} ${diff.inHours == 1 ? "hora" : "horas"}';
    } else {
      return 'Hace ${diff.inDays} ${diff.inDays == 1 ? "día" : "días"}';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        reminder.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatDate(
                              DateFormat('dd/MM/yyyy').parse(reminder.date),
                            ),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "\n${reminder.date}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                reminder.content,
                style: const TextStyle(color: Colors.black87),
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
