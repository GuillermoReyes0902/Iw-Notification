import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:provider/provider.dart';

class UsersList extends StatelessWidget {
  const UsersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<NotificationProvider, List<UserModel>>(
      selector: (_, controller) => controller.users,
      builder: (_, users, __) {
        return Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.all(4),
          color: Colors.amber,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Lista de usuarios temporal",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(users[index].name);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
