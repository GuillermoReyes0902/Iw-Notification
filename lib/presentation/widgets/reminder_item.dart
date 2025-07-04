import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/reminder_model.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:iwproject/presentation/pages/message_sender_screen.dart';
import 'package:iwproject/utils/text_data.dart';
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

    if (diffDays == 0) return TextData.timeAgo[0];
    if (diffDays == 1) return TextData.timeAgo[1];
    if (diffDays < 30) {
      return '${TextData.timeAgo[2]}$diffDays${TextData.timeAgo[3]}';
    }
    if (diffDays < 365) {
      return '${TextData.timeAgo[2]}${(diffDays / 30).floor()}${TextData.timeAgo[4]}';
    }
    return '${TextData.timeAgo[2]}${(diffDays / 365).floor()}${TextData.timeAgo[5]}';
  }

  Future<void> markAsCompleted(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection(ConstantData.reminderCollection)
          .doc(reminder.id)
          .update({ConstantData.reminderCompleted: !reminder.completed});
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al actualizar: $e')));
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
                      const SizedBox(width: 6),
                      Consumer<NotificationProvider>(
                        builder: (context, controller, _) {
                          if (controller.users.isEmpty) return const SizedBox();

                          final sender = controller.users.firstWhere(
                            (user) => user.id == reminder.senderId,
                            orElse: () => UserModel(id: '', name: 'Desconocido', photo: ''),
                          );

                          String receiversText = '';
                          if (reminder.receiversIds != null && reminder.receiversIds!.isNotEmpty) {
                            final receivers = controller.users
                                .where((u) => reminder.receiversIds!.contains(u.id))
                                .toList();

                            receiversText = receivers.map((u) => u.name).join(', ');
                          } else {
                            final receiver = controller.users.firstWhere(
                              (user) => user.id == reminder.receiverId,
                              orElse: () => UserModel(id: '', name: 'Desconocido', photo: ''),
                            );
                            receiversText = receiver.name;
                          }

                          return Text(
                            "${TextData.sender}${sender.name}\n${TextData.receiver}$receiversText",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
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
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatDate(reminder.date),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "\n${ConstantData.dateFormat.format(reminder.date)}",
                        textAlign: TextAlign.end,
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

              // CONTENIDO
              Text(
                reminder.content,
                style: TextStyle(
                  color: reminder.completed ? Colors.grey : Colors.black87,
                  decoration: reminder.completed
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Fecha límite: ${ConstantData.onlyDateFormat.format(reminder.deadline)}",
                textAlign: TextAlign.end,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                "Prioridad: ${reminder.priority}",
                textAlign: TextAlign.end,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),

              // BOTÓN
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Selector<NotificationProvider, UserModel?>(
                    selector: (_, controller) => controller.currentUser,
                    builder: (_, currentUser, _) {
                      final isOwner = currentUser?.id == reminder.senderId;
                      if (!isOwner) return const SizedBox();

                      return TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MessageSenderScreen(reminder: reminder),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text("Editar"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black54,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Selector<NotificationProvider, UserModel?>(
                    selector: (_, controller) => controller.currentUser,
                    builder: (_, currentUser, _) {
                      final isReceiver = currentUser?.id == reminder.receiverId;
                      if (!isReceiver) return const SizedBox();
                      return TextButton.icon(
                        onPressed: () => markAsCompleted(context),
                        icon: Icon(
                          reminder.completed
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          size: 18,
                        ),
                        label: Text(
                          reminder.completed
                              ? TextData.completedState[0]
                              : TextData.completedState[1],
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: reminder.completed
                              ? Colors.green
                              : Colors.black54,
                        ),
                      );
                    },
                  ),
                ],
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
