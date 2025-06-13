import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iwproject/domain/models/reminder_model.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/presentation/pages/message_sender_screen.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
//import 'package:iwproject/presentation/providers/reminder_listener_provider.dart';
import 'package:iwproject/presentation/widgets/reminder_item.dart';
import 'package:iwproject/presentation/widgets/users_dropdown.dart';
//import 'package:provider/provider.dart';
import 'package:iwproject/utils/text_data.dart';
import 'package:provider/provider.dart';

class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final listener = context.read<ReminderListenerProvider>();
    // listener.setCurrentScreen('NotificationList');
    // listener.startListening(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessageSenderScreen(),
                ),
              ),
              icon: const Icon(Icons.send, size: 18),
              label: const Text(TextData.newReminderButton),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black87,
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.message_outlined, size: 20),
                          SizedBox(width: 8),
                          Text(
                            TextData.messageListTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      /// Dropdown para filtrar
                      UsersDropDown(origin: DropDownOrigin.mainlist),

                      const SizedBox(height: 16),
                      Selector<NotificationProvider, UserModel?>(
                        selector: (_, controller) =>
                            controller.selectedReceiverMainList,
                        builder: (_, selectedReceiverMainList, _) {
                          return StreamBuilder<QuerySnapshot>(
                            stream: selectedReceiverMainList == null
                                ? FirebaseFirestore.instance
                                      .collection(
                                        ConstantData.reminderCollection,
                                      )
                                      .snapshots()
                                : FirebaseFirestore.instance
                                      .collection(
                                        ConstantData.reminderCollection,
                                      )
                                      .where(
                                        ConstantData.reminderReceiverId,
                                        isEqualTo: selectedReceiverMainList.id,
                                      )
                                      .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                  'Error: ${snapshot.error}',
                                  style: const TextStyle(color: Colors.grey),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: CircularProgressIndicator(),
                                );
                              }

                              final docs = snapshot.data?.docs ?? [];

                              if (docs.isEmpty) {
                                return const Text(
                                  TextData.empptyReminders,
                                  style: TextStyle(color: Colors.grey),
                                );
                              }

                              final reminders = docs.map((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                return ReminderModel.fromJson({
                                  ConstantData.reminderId: doc.id,
                                  ...data,
                                });
                              }).toList();

                              reminders.sort(
                                (a, b) => b.date.compareTo(a.date),
                              );

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${TextData.messageListSubtitle[0]}${reminders.length}${TextData.messageListSubtitle[1]}",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: reminders.length,
                                    itemBuilder: (context, index) {
                                      final reminder = reminders[index];
                                      return ReminderItem(
                                        reminder: reminder,
                                        isLastReminder:
                                            index < reminders.length - 1,
                                      );
                                    },
                                  ),
                                ],
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
        ),
      ),
    );
  }
}
