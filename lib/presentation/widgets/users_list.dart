import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:provider/provider.dart';

class UsersList extends StatelessWidget {
  final UserModel? selectedUser;
  final void Function(UserModel?) onChanged;
  final String hint;
  final bool showAllOption; 

  const UsersList({
    super.key,
    required this.selectedUser,
    required this.onChanged,
    required this.hint,
    this.showAllOption = false, 
  });

  @override
  Widget build(BuildContext context) {
    return Selector<NotificationProvider, List<UserModel>>(
      selector: (_, controller) => controller.users,
      builder: (_, users, __) {
        final List<DropdownMenuItem<UserModel>> items = [];

        // Opción "Todos" solo si está activado
        if (showAllOption) {
          items.add(
            DropdownMenuItem<UserModel>(
              value: null,
              child: Row(
                children: const [
                  Icon(Icons.group, size: 16, color: Colors.grey),
                  SizedBox(width: 6),
                  Text('Todos', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          );
        }

        // Lista normal de usuarios
        items.addAll(
          users.map(
            (user) => DropdownMenuItem<UserModel>(
              value: user,
              child: Text(user.name),
            ),
          ),
        );

        return DropdownButtonFormField<UserModel>(
          value: selectedUser,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: items,
          onChanged: onChanged,
          validator: (_) => null,
        );
      },
    );
  }
}
