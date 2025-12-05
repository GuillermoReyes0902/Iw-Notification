import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:provider/provider.dart';

class UserItem extends StatelessWidget {
  const UserItem({super.key, required this.user});

  final UserModel user;
  Future<void> loginUser(UserModel selectedUser, BuildContext context) async {
    final controller = context.read<NotificationProvider>();
    await controller.logIn(selectedUser);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await loginUser(user, context),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(200)),
            child: Image.asset(
              user.photo,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Text(
            user.name,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
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
