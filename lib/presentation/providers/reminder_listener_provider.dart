// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:iwproject/utils/local_notification_handler.dart';

// class ReminderListenerProvider with ChangeNotifier {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   StreamSubscription<QuerySnapshot>? _subscription;

//   String? _currentScreen;

//   void setCurrentScreen(String screenName) {
//     _currentScreen = screenName;
//   }

//   void startListening(BuildContext context) async {
//     _subscription?.cancel(); // detener si ya está escuchando
//     _subscription = _db.collection('reminders').snapshots().listen((
//       snapshot,
//     ) async {
//       if (snapshot.docChanges.any((c) => c.type == DocumentChangeType.added)) {
//         if (_currentScreen == 'NotificationList') {
//           debugPrint("estoy aquí");
//         } else if (_currentScreen == 'MessageSender') {
//           debugPrint("estoy en mensaje");
//         }
//         await LocalNotificationHandler.showNotification(
//           "Nuevo recordatorio añadido",
//           "Ver",
//         );
//       }
//     });
//   }

//   void stopListening() {
//     _subscription?.cancel();
//   }

//   void disposeListener() {
//     stopListening();
//   }
// }
