import 'package:flutter/material.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:iwproject/presentation/providers/reminder_listener_provider.dart';
//import 'package:iwproject/presentation/providers/reminder_listener_provider.dart';
import 'package:iwproject/presentation/widgets/users_dropdown.dart';
import 'package:iwproject/utils/text_data.dart';
import 'package:provider/provider.dart';

class MessageSenderScreen extends StatelessWidget {
  const MessageSenderScreen({super.key});

  void goToNotificationList(BuildContext context) async {
    Navigator.pop(context);
  }

  Future<void> saveReminder(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final controller = context.read<NotificationProvider>();
    await controller.saveReminder().then((value) {
      if (value == true) {
        if (!context.mounted) return;
        goToNotificationList(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final listener = context.read<ReminderListenerProvider>();
    listener.startListening(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: TextButton.icon(
          onPressed: () => goToNotificationList(context),
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          label: const Text(TextData.reminderListButton),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black87,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        leadingWidth: 200,
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
                          Icon(Icons.send, size: 20),
                          SizedBox(width: 8),
                          Text(
                            TextData.messageSenderTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        TextData.messageSenderSubtitle,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      Consumer<NotificationProvider>(
                        builder: (context, controller, _) {
                          return Form(
                            key: controller.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Remitente
                                const Text(
                                  TextData.selectSender,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                UsersDropDown(origin: DropDownOrigin.sender),
                                const SizedBox(height: 8),
                                const Text(
                                  TextData.selectReciver,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                UsersDropDown(origin: DropDownOrigin.receiver),
                                const SizedBox(height: 8),
                                // Contenido
                                const Text(
                                  TextData.content,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: controller.contenidoCtrl,
                                  maxLines: 6,
                                  decoration: InputDecoration(
                                    hintText: TextData.contentHint,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  validator: (value) =>
                                      value == "" || value == null
                                      ? TextData.contentValidator
                                      : null,
                                ),
                                const SizedBox(height: 24),
                                // Botón
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => saveReminder(context),
                                    icon: const Icon(Icons.send),
                                    label: const Text(
                                      TextData.sendReminderButton,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
