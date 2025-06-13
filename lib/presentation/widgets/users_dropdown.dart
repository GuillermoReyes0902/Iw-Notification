import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:iwproject/utils/text_data.dart';
import 'package:provider/provider.dart';

enum DropDownOrigin { mainlist, sender, receiver }

class UsersDropDown extends StatelessWidget {
  final DropDownOrigin origin;

  const UsersDropDown({super.key, required this.origin});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, controller, _) {
        final List<DropdownMenuItem<UserModel>> items = [];
        // Opción "Todos" solo si está activado
        if (origin == DropDownOrigin.mainlist) {
          items.add(
            DropdownMenuItem<UserModel>(
              value: null,
              child: Row(
                children: const [
                  Icon(Icons.group, size: 16, color: Colors.grey),
                  SizedBox(width: 6),
                  Text(TextData.all, style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          );
        }

        // Lista normal de usuarios
        items.addAll(
          controller.users.map(
            (user) => DropdownMenuItem<UserModel>(
              value: user,
              child: Text(user.name),
            ),
          ),
        );

        return DropdownButtonFormField<UserModel>(
          value: origin == DropDownOrigin.sender
              ? controller.selectedSender
              : origin == DropDownOrigin.receiver
              ? controller.selectedReceiver
              : controller.selectedReceiverMainList,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: items,
          onChanged: (value) => origin == DropDownOrigin.sender
              ? controller.setSender(value)
              : origin == DropDownOrigin.receiver
              ? controller.setReceiver(value)
              : controller.setMainListReceiver(value),
          validator: (value) =>
              (value == null && origin != DropDownOrigin.mainlist)
              ? origin == DropDownOrigin.sender
                    ? TextData.senderValidator
                    : TextData.receiverValidator
              : null,
        );
      },
    );
  }
}
