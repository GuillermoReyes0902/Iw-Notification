// import 'package:firebase_messaging/firebase_messaging.dart';

// class NotificationService {
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   requestPermission() async {
//     //PERMISO
//     try {
//       NotificationSettings settings = await _firebaseMessaging
//           .requestPermission()

//       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//         print('User granted permission');
//       } else if (settings.authorizationStatus ==
//           AuthorizationStatus.provisional) {
//         print('User granted provisional permission');
//       } else {
//         print('User declined or has not accepted permission');
//       }
//     } catch (e) {
//       print("Error requesting notification permission: $e");
//     }

//     //TOKEN
//     String? token = await _firebaseMessaging.getToken();
//     print("Firebase Messaging Token: $token");

//     //LISTENERS
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('[onMessageOpenedApp] message: $message');
//     });

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('[onMessage] message: $message');
//     });

//     FirebaseMessaging.onBackgroundMessage((RemoteMessage message) {
//       print('[onBackgroundMessage] message: $message');
//       return Future.value();
//     });
//   }
// }
