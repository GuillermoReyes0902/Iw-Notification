import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:iwproject/presentation/widgets/user_item.dart';
import 'package:iwproject/utils/text_data.dart';
import 'package:provider/provider.dart';

class UserLoginScreen extends StatelessWidget {
  const UserLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
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
                  padding: EdgeInsetsGeometry.only(
                    top: Platform.isWindows || Platform.isMacOS ? 24 : 12,
                    right: Platform.isWindows || Platform.isMacOS ? 24 : 12,
                    left: Platform.isWindows || Platform.isMacOS ? 24 : 12,
                    bottom: Platform.isWindows || Platform.isMacOS ? 48 : 24,
                  ),
                  child: Column(
                    children: [
                      Text(
                        TextData.loginTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Selector<NotificationProvider, List<UserModel>>(
                        selector: (_, controller) => controller.users,
                        builder: (_, users, _) {
                          return GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  childAspectRatio:
                                      Platform.isWindows || Platform.isMacOS
                                      ? 1.25
                                      : 0.65,
                                ),
                            itemCount: users.length,
                            itemBuilder: (BuildContext context, int index) {
                              final user = users[index];
                              return UserItem(user: user);
                            },
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
