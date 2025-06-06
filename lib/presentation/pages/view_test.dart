import 'package:flutter/material.dart';
import 'package:iwproject/presentation/pages/notification_page.dart';

class MessageSenderScreen extends StatelessWidget {
  const MessageSenderScreen({super.key});

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
            padding: const EdgeInsets.only(right: 16.0, top: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MensajesRecibidosScreen()),
                );
              },
              icon: const Icon(Icons.inbox, size: 18),
              label: const Text("Ver mensajes recibidos"),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Formulario de envío
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                                'Enviar Nuevo Mensaje',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Completa los campos para enviar un mensaje',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 24),

                          // Remitente
                          const Text('Remitente', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          TextField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person_outline),
                              hintText: 'Ingresa el nombre del remitente',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Contenido
                          const Text('Contenido del Mensaje', style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          TextField(
                            maxLines: 6,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.message_outlined),
                              hintText: 'Escribe el contenido del mensaje aquí...',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Botón
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {}, // sin funcionalidad
                              icon: const Icon(Icons.send),
                              label: const Text('Enviar Mensaje'),
                            ),
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
