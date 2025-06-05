import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iwproject/domain/models/reminder_model.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.ref().child('reminders');

    Future<void> saveReminder() async {
      final controller = context.read<NotificationProvider>();
      final newRef = ref.push(); // Genera una clave única
      if (controller.formKey.currentState!.validate()) {
        await newRef
            .set({
              "name": controller.emisorCtrl.text.trim(),
              "content": controller.contenidoCtrl.text.trim(),
              "date": DateFormat('dd/MM/yyyy').format(DateTime.now()),
            })
            .then((_) {
              controller.formKey.currentState!.reset();
            });
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Crear un recordatorio",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Consumer<NotificationProvider>(
              builder: (context, controller, _) {
                return Form(
                  key: controller.formKey,
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controller.emisorCtrl,
                          decoration: InputDecoration(hintText: "Emisor"),
                          validator: (value) => value == "" || value == null
                              ? "Emisor vacío"
                              : null,
                        ),
                        TextFormField(
                          controller: controller.contenidoCtrl,
                          decoration: InputDecoration(hintText: "Contenido"),
                          validator: (value) => value == "" || value == null
                              ? "Contenido vacío"
                              : null,
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(vertical: 20),
                          child: ElevatedButton(
                            onPressed: () => saveReminder(),
                            child: Text("Subir"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            Text(
              "Listado de recordatorios",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            StreamBuilder<DatabaseEvent>(
              stream: ref.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return Center(child: Text('No data available.'));
                }

                final data = snapshot.data!.snapshot.value;

                // Convertir los datos a Map
                Map<dynamic, dynamic> remindersMap =
                    data as Map<dynamic, dynamic>;

                // Convertir cada valor a ReminderModel
                final reminders = remindersMap.values.map((json) {
                  // Asegúrate de que sea Map<String, dynamic>
                  return ReminderModel.fromJson(
                    Map<String, dynamic>.from(json),
                  );
                }).toList();

                reminders.sort((a, b) {
                  final dateA = DateFormat('dd/MM/yyyy').parse(a.date);
                  final dateB = DateFormat('dd/MM/yyyy').parse(b.date);
                  return dateB.compareTo(dateA);
                });

                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shrinkWrap: true,
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = reminders[index];
                    return ListTile(
                      title: Text(reminder.name),
                      subtitle: Text('${reminder.date} - ${reminder.content}'),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
