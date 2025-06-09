import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:iwproject/domain/models/reminder_model.dart';
import 'package:iwproject/presentation/widgets/reminder_item.dart';

class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.ref().child('reminders');
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: SizedBox(
          child: TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text("Volver a enviar"),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
        leadingWidth: 150,
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
                            "Recordatorios Recibidos",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      StreamBuilder<DatabaseEvent>(
                        stream: ref.onValue,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.grey),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                vertical: 20,
                              ),
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.snapshot.value == null) {
                            return Text(
                              "No hay recordatorios en tu bandeja de entrada",
                              style: const TextStyle(color: Colors.grey),
                            );
                          }

                          final data = snapshot.data!.snapshot.value;

                          Map<dynamic, dynamic> remindersMap =
                              data as Map<dynamic, dynamic>;

                          final reminders = remindersMap.entries.map((entry) {
                            final key = entry
                                .key; // Esta es la key del nodo en Firebase
                            final value = Map<String, dynamic>.from(
                              entry.value,
                            );

                            // Asignamos manualmente el id al objeto ReminderModel
                            return ReminderModel.fromJson({
                              'id': key,
                              ...value,
                            });
                          }).toList();

                          reminders.sort((a, b) {
                            // final dateA = DateFormat(
                            //   'dd/MM/yyyy',
                            // ).parse(a.date);
                            // final dateB = DateFormat(
                            //   'dd/MM/yyyy',
                            // ).parse(b.date);
                            return b.date.compareTo(a.date);
                          });

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reminders.isEmpty
                                    ? "No hay recordatorios en tu bandeja de entrada"
                                    : "Tienes ${reminders.length} recordatorios en tu bandeja de entrada",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: reminders.length,
                                itemBuilder: (context, index) {
                                  final reminder = reminders[index];
                                  return ReminderItem(
                                    reminder: reminder,
                                    isLastReminder:
                                        (index < reminders.length - 1),
                                  );
                                },
                              ),
                            ],
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
