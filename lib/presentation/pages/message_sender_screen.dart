import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iwproject/domain/models/reminder_model.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:iwproject/presentation/widgets/users_dropdown.dart';
import 'package:iwproject/utils/text_data.dart';
//import 'package:iwproject/presentation/providers/reminder_listener_provider.dart';

class MessageSenderScreen extends StatelessWidget {
  final ReminderModel? reminder;
  const MessageSenderScreen({super.key, this.reminder});

  void goToNotificationList(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> saveReminder(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final controller = context.read<NotificationProvider>();
    final success = await controller.saveReminder();
    if (success && context.mounted) {
      goToNotificationList(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<NotificationProvider>();

    // Si viene recordatorio, carga datos en el formulario
    if (reminder != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.setReminderDataForEditing(reminder!);
      });
    }

    // final listener = context.read<ReminderListenerProvider>();
    // final controllerNotification = context.read<NotificationProvider>();
    // listener.startListening(context, controllerNotification.currentUser!.id);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          context.read<NotificationProvider>().clearForm();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: TextButton.icon(
            onPressed: () {
              context.read<NotificationProvider>().clearForm();
              goToNotificationList(context);
            },
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
                        const SizedBox(height: 14),
                        Consumer<NotificationProvider>(
                          builder: (context, controller, _) {
                            return Form(
                              key: controller.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    TextData.receiver,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const UsersDropDown(
                                    origin: DropDownOrigin.receiver,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    TextData.content,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
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
                                        value == null || value.isEmpty
                                        ? TextData.contentValidator
                                        : null,
                                  ),
                                  const SizedBox(height: 24),
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
      ),
    );
  }
}
