import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iwproject/domain/models/reminder_model.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/presentation/pages/message_sender_screen.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:iwproject/presentation/widgets/projects_dropdown.dart';
import 'package:iwproject/presentation/widgets/reminder_item_grid.dart';
import 'package:iwproject/presentation/widgets/users_dropdown.dart';
import 'package:iwproject/utils/data.dart';
import 'package:provider/provider.dart';
import 'package:iwproject/utils/text_data.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    newReminderButton() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MessageSenderScreen()),
      );
    }

    exitButton() {
      final controller = context.read<NotificationProvider>();
      controller.logOut();
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: Platform.isWindows || Platform.isMacOS
          ? FloatingActionButton.extended(
              onPressed: newReminderButton,
              label: Text(TextData.newReminderButton),
            )
          : FloatingActionButton(
              onPressed: newReminderButton,
              child: Icon(Icons.add),
            ),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: TextButton(
              onPressed: () => exitButton(),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black87,
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
                elevation: 0,
              ),
              child: const Text(TextData.logOutButton),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 950),
            child: Padding(
              padding: EdgeInsets.only(
                left: Platform.isWindows || Platform.isMacOS ? 24 : 12,
                right: Platform.isWindows || Platform.isMacOS ? 24 : 12,
                bottom: Platform.isWindows || Platform.isMacOS ? 24 : 12,
                top: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Dropdown para filtrar
                  SizedBox(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Selector<NotificationProvider, UserModel?>(
                              selector: (_, controller) =>
                                  controller.currentUser,
                              builder: (_, currentUser, _) {
                                return Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                      child: Image.asset(
                                        currentUser!.photo,
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "Bienvenido/a ${currentUser.name}",
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),

                        Platform.isWindows || Platform.isMacOS
                            ? FiltersWidget()
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                  Platform.isAndroid || Platform.isIOS
                      ? Padding(
                          padding: EdgeInsetsGeometry.symmetric(vertical: 12),
                          child: FiltersWidget(),
                        )
                      : SizedBox(height: 8),

                  Consumer<NotificationProvider>(
                    builder: (context, controller, _) {
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection(ConstantData.reminderCollection)
                            .snapshots(),
                        builder: (context, snapshot) {
                          final docs = snapshot.data?.docs ?? [];

                          if (docs.isEmpty) {
                            return const Text(
                              TextData.empptyReminders,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            );
                          }

                          var allReminders = docs.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            return ReminderModel.fromJson({
                              ConstantData.reminderId: doc.id,
                              ...data,
                            });
                          }).toList();

                          // Ordenamos primero por prioridad y luego por fecha
                          allReminders.sort((a, b) {
                            // Definir el orden de prioridad
                            const priorityOrder = {
                              'alta': 3,
                              'intermedia': 2,
                              'baja': 1,
                            };

                            final priorityA =
                                priorityOrder[a.priority.toLowerCase()] ?? 0;
                            final priorityB =
                                priorityOrder[b.priority.toLowerCase()] ?? 0;

                            // Primero compara por prioridad
                            if (priorityA != priorityB) {
                              return priorityB.compareTo(
                                priorityA,
                              ); // mayor prioridad primero
                            }

                            // Si tienen la misma prioridad, ordena por fecha descendente
                            return a.deadline.compareTo(b.deadline);
                          });

                          // Aplicamos ambos filtros
                          final selectedUser =
                              controller.selectedReceiverMainList;
                          final selectedProject =
                              controller.selectedProjectMainList;

                          final reminders = allReminders.where((r) {
                            bool userMatch = true;
                            bool projectMatch = true;

                            if (selectedUser != null) {
                              userMatch =
                                  r.receiverId == selectedUser.id ||
                                  (r.receiversIds.contains(selectedUser.id));
                            }

                            if (selectedProject != null) {
                              projectMatch = r.projectId == selectedProject.id;
                            }

                            return userMatch && projectMatch;
                          }).toList();

                          return Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${TextData.messageListSubtitle[0]}${reminders.length}${TextData.messageListSubtitle[1]}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              Platform.isWindows ||
                                                  Platform.isMacOS
                                              ? 3
                                              : 2,
                                          mainAxisSpacing: 0,
                                          crossAxisSpacing: 12,
                                          childAspectRatio:
                                              Platform.isWindows ||
                                                  Platform.isMacOS
                                              ? 0.85
                                              : 0.55,
                                        ),
                                    itemCount: reminders.length,
                                    itemBuilder: (context, index) {
                                      final reminder = reminders[index];
                                      return ReminderItemGrid(
                                        reminder: reminder,
                                        isLastReminder:
                                            index < reminders.length - 1,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FiltersWidget extends StatelessWidget {
  const FiltersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Text(
              "Colaborador: ",
              style: TextStyle(color: Colors.grey[400]!, fontSize: 14),
            ),
            Platform.isWindows || Platform.isMacOS
                ? SizedBox(width: 300, child: BasicUsersDropDown())
                : Expanded(child: BasicUsersDropDown()),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Text(
              "Proyecto: ",
              style: TextStyle(color: Colors.grey[400]!, fontSize: 14),
            ),
            Platform.isWindows || Platform.isMacOS
                ? SizedBox(width: 300, child: BasicProjectDropdown())
                : Expanded(child: BasicProjectDropdown()),
          ],
        ),
      ],
    );
  }
}
