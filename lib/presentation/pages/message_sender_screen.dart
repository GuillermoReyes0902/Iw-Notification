import 'package:flutter/material.dart';
import 'package:iwproject/presentation/pages/notification_list_screen.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:provider/provider.dart';

class MessageSenderScreen extends StatelessWidget {
  const MessageSenderScreen({super.key});

  void goToNotificationList(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationListScreen()),
    );
  }

  Future<void> saveReminder(BuildContext context) async {
    final controller = context.read<NotificationProvider>();
    await controller.saveReminder().then((value) {
      print(value);
      if (value == true) {
        goToNotificationList(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => goToNotificationList(context),
              icon: const Icon(Icons.inbox, size: 18),
              label: const Text("Ver recordatorios"),
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
                          Icon(Icons.send, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Enviar Nuevo Recordatorio',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Completa los campos para enviar un recordatorio',
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
                                  'Remitente',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: controller.emisorCtrl,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.person_outline,
                                    ),
                                    hintText: 'Ingresa tu nombre',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  validator: (value) =>
                                      value == "" || value == null
                                      ? "Remitente vacío"
                                      : null,
                                ),
                                const SizedBox(height: 24),

                                // Contenido
                                const Text(
                                  'Contenido del recordatorio',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: controller.contenidoCtrl,
                                  maxLines: 6,
                                  decoration: InputDecoration(
                                    hintText: 'Escribe el recordatorio aquí...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  validator: (value) =>
                                      value == "" || value == null
                                      ? "Contenido vacío"
                                      : null,
                                ),
                                const SizedBox(height: 24),
                                // Botón
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => saveReminder(context),
                                    icon: const Icon(Icons.send),
                                    label: const Text('Enviar Recordatorio'),
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
