import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:provider/provider.dart';

class UserItem extends StatelessWidget {
  const UserItem({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    void loginUser(UserModel selectedUser) {
      final controller = context.read<NotificationProvider>();
      controller.logIn(selectedUser);
    }

    return GestureDetector(
      onTap: () => loginUser(user),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(200)),
            child: Image.asset(user.photo, height: 100, width: 100),
          ),
          SizedBox(height: 8),
          Text(
            user.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
