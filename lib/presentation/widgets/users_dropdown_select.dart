import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:iwproject/utils/text_data.dart';
import 'package:provider/provider.dart';

class UsersDropDownSelect extends StatefulWidget {
  const UsersDropDownSelect({super.key});

  @override
  State<UsersDropDownSelect> createState() => _UsersDropDownState();
}

class _UsersDropDownState extends State<UsersDropDownSelect> {
  final _dropdownKey = GlobalKey<DropdownSearchState<UserModel>>();
  List<UserModel> _currentSelections = [];
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, controller, _) {
        if (_currentSelections.isEmpty) {
          _currentSelections = List.from(controller.selectedReceivers);
        }

        return Listener(
          onPointerDown: (_) => controller.setReceivers(_currentSelections),
          child: DropdownSearch<UserModel>.multiSelection(
            key: _dropdownKey,
            items: controller.users,
            selectedItems: controller.selectedReceivers,
            itemAsString: (u) => u.name,
            compareFn: (a, b) => a.id == b.id,
            popupProps: PopupPropsMultiSelection.menu(
              showSelectedItems: true,
              showSearchBox: false,
              constraints: const BoxConstraints(maxHeight: 500),
              menuProps: const MenuProps(),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: TextData.receiver,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            onChanged: (List<UserModel> selected) {
              setState(() {
                _currentSelections = List.from(selected);
              });
              controller.setReceivers(_currentSelections);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return TextData.receiverValidator;
              }
              return null;
            },
          ),
        );
      },
    );
  }
}
