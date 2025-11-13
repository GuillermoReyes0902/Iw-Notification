import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/project_model.dart';
import 'package:iwproject/domain/models/reminder_model.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/presentation/pages/message_sender_screen.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:iwproject/utils/data.dart';
import 'package:iwproject/utils/text_data.dart';
import 'package:provider/provider.dart';

class ReminderItemGrid extends StatelessWidget {
  const ReminderItemGrid({
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
    final bool isCompleted = reminder.status == 'completado';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Consumer<NotificationProvider>(
            builder: (context, controller, _) {
              if (controller.users.isEmpty) return const SizedBox();

              final projectObject = controller.projects.firstWhere(
                (p) => p.id == reminder.projectId,
                orElse: () => ProjectModel(id: '', name: 'No asignado'),
              );

              final sender = controller.users.firstWhere(
                (user) => user.id == reminder.senderId,
                orElse: () => UserModel(id: '', name: 'Desconocido', photo: ''),
              );

              final receivers = controller.users
                  .where((u) => reminder.receiversIds.contains(u.id))
                  .toList();

              final isSender = sender.id == controller.currentUser!.id;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: reminder.receiverId == controller.currentUser!.id
                        ? DropdownButton<String>(
                            value: reminder.status,
                            padding: EdgeInsets.zero,
                            isDense: true,
                            items: TextData.statusOptions.entries.map((entry) {
                              final statusValue = entry.key;
                              final label = entry.value;

                              return DropdownMenuItem<String>(
                                value: statusValue,
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    color: ConstantData.getStatusColor(
                                      statusValue,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) async {
                              if (newValue == null) return;
                              await FirebaseFirestore.instance
                                  .collection(ConstantData.reminderCollection)
                                  .doc(reminder.id)
                                  .update({
                                    ConstantData.reminderStatus: newValue,
                                  });
                            },
                            underline: const SizedBox(),

                            style: TextStyle(
                              color: ConstantData.getStatusColor(
                                reminder.status,
                              ),
                            ),
                            dropdownColor: Colors.white,
                            iconEnabledColor: ConstantData.getStatusColor(
                              reminder.status,
                            ),
                          )
                        : Padding(
                            padding: EdgeInsetsGeometry.only(bottom: 3),
                            child: Text(
                              TextData.statusOptions[reminder.status]!,
                              style: TextStyle(
                                color: ConstantData.getStatusColor(
                                  reminder.status,
                                ),
                              ),
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: TextData.priorityColors[reminder.priority]!
                                .withValues(alpha: 0.2),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          child: Text(
                            reminder.priority.toUpperCase(),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 12,
                              color: TextData.priorityColors[reminder.priority],
                            ),
                          ),
                        ),
                        Spacer(),
                        isSender
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MessageSenderScreen(
                                        reminder: reminder,
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.edit,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      projectObject.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: projectObject.id.isEmpty
                            ? Colors.grey
                            : Colors.black87,
                        fontWeight: projectObject.id.isNotEmpty
                            ? FontWeight.bold
                            : null,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SizedBox(
                      height:
                          (projectObject.name.length > 25 &&
                              receivers.length == 9)
                          ? (15 * 3.75)
                          : (projectObject.name.length < 25 &&
                                receivers.length < 5)
                          ? (15 * 9.5)
                          : (projectObject.name.length > 25 &&
                                    receivers.length > 4) ||
                                (projectObject.name.length < 25 &&
                                    receivers.length == 9)
                          ? (15 * 5.5)
                          : (15 * 7.75),

                      child: SingleChildScrollView(
                        child: Text(
                          reminder.content,
                          style: TextStyle(
                            color: Colors.grey,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Divider(),
                  ),
                  SizedBox(
                    //height: 30,
                    child: Row(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 3,
                                  crossAxisSpacing: 0,
                                  childAspectRatio: 1.5,
                                ),
                            shrinkWrap: true,
                            itemCount: receivers.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {
                              return Center(
                                child: SizedBox(
                                  width: 30, // tamaño del círculo
                                  height: 30,
                                  child: ClipOval(
                                    child: Image.asset(
                                      receivers[index].photo,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Text(
                          "🚩${ConstantData.onlyDateFormat.format(reminder.deadline)}",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
