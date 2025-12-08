import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:iwproject/utils/text_data.dart';
import 'package:provider/provider.dart';

class BasicUsersDropDown extends StatelessWidget {
  const BasicUsersDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, controller, _) {
        final List<DropdownMenuItem<UserModel>> items = [];

        items.add(
          DropdownMenuItem<UserModel>(
            value: null,
            child: Row(
              children: [
                Icon(
                  Icons.group,
                  size: Platform.isWindows || Platform.isMacOS ? 14 : 16,
                  color: Colors.grey[400]!,
                ),
                SizedBox(width: 6),
                Text(
                  TextData.all,
                  style: TextStyle(
                    color: Colors.grey[400]!,
                    fontSize: Platform.isWindows || Platform.isMacOS ? 12 : 14,
                  ),
                ),
              ],
            ),
          ),
        );

        items.addAll(
          controller.users.map(
            (user) => DropdownMenuItem<UserModel>(
              value: user,
              child: Text(
                user.name,
                style: TextStyle(
                  fontSize: Platform.isWindows || Platform.isMacOS ? 12 : 14,
                ),
              ),
            ),
          ),
        );

        return SizedBox(
          height: Platform.isWindows || Platform.isMacOS ? 45 : 50,
          child: DropdownButtonFormField<UserModel>(
            iconEnabledColor: Colors.grey[400]!,
            isDense: true,
            value: controller.selectedReceiverMainList,
            decoration: InputDecoration(
              // Definimos el mismo borde gris para todos los estados
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
              ),
            ),
            items: items,
            onChanged: (value) => controller.setMainListReceiver(value),
            validator: (value) => null,
          ),
        );
      },
    );
  }
}
