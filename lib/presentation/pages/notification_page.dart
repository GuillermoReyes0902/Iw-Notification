import 'package:flutter/material.dart';
import 'package:iwproject/presentation/pages/view_test.dart';

class ReceivedMessage {
  final int id;
  final String sender;
  final String content;
  final DateTime timestamp;
  final bool read;

  ReceivedMessage({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.read,
  });
}

class MensajesRecibidosScreen extends StatefulWidget {
  const MensajesRecibidosScreen({super.key});

  @override
  State<MensajesRecibidosScreen> createState() => _MensajesRecibidosScreenState();
}

class _MensajesRecibidosScreenState extends State<MensajesRecibidosScreen> {
  List<ReceivedMessage> messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    messages = [
      ReceivedMessage(
        id: 1,
        sender: "María González",
        content:
            "Hola, ¿cómo estás? Te escribo para confirmar nuestra reunión de mañana a las 10:00 AM. Por favor avísame si necesitas cambiar la hora.",
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        read: false,
      ),
      ReceivedMessage(
        id: 2,
        sender: "Juan Pérez",
        content:
            "Te envío los documentos que solicitaste. Revísalos cuando puedas y me dices si necesitas alguna modificación.",
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        read: true,
      ),
      ReceivedMessage(
        id: 3,
        sender: "Carlos Rodríguez",
        content:
            "Recordatorio: mañana es la fecha límite para entregar el informe mensual. Si tienes alguna duda, estoy disponible para ayudarte.",
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        read: true,
      ),
      ReceivedMessage(
        id: 4,
        sender: "Ana Martínez",
        content: "¿Podrías enviarme el archivo del proyecto? Lo necesito para la presentación de esta tarde.",
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        read: false,
      ),
    ];
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

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
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Botón volver
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MessageSenderScreen()),
                        );
                      },
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text("Volver a enviar"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Card de mensajes
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                                "Mensajes Recibidos",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            messages.isEmpty
                                ? "No hay mensajes en tu bandeja de entrada"
                                : "Tienes ${messages.length} mensajes en tu bandeja de entrada",
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),

                          Column(
                            children: messages.asMap().entries.map((entry) {
                              final index = entry.key;
                              final message = entry.value;
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
                                                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                                                const SizedBox(width: 6),
                                                Text(
                                                  message.sender,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.w600, color: Colors.black87),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                                const SizedBox(width: 4),
                                                Text(
                                                  formatDate(message.timestamp),
                                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(message.content, style: const TextStyle(color: Colors.black87)),
                                      ],
                                    ),
                                  ),
                                  if (index < messages.length - 1)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      child: Divider(),
                                    ),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
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
