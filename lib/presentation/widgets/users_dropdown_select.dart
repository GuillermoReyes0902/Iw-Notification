import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:iwproject/domain/models/user_model.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:iwproject/utils/text_data.dart';
import 'package:provider/provider.dart';

enum DropDownOrigin { mainlist, receiver }

class UsersDropDown extends StatefulWidget {
  final DropDownOrigin origin;
  const UsersDropDown({super.key, required this.origin});

  @override
  State<UsersDropDown> createState() => _UsersDropDownState();
}

class _UsersDropDownState extends State<UsersDropDown> {
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
        final isMulti = widget.origin == DropDownOrigin.receiver;
        final selectedUsers = isMulti
            ? controller.selectedReceivers
            : controller.selectedReceiversMainList;

        if (_currentSelections.isEmpty) {
          _currentSelections = List.from(selectedUsers);
        }

        return Listener(
          onPointerDown: (_) => _saveSelections(controller),
          child: DropdownSearch<UserModel>.multiSelection(
            key: _dropdownKey,
            items: controller.users,
            selectedItems: selectedUsers,
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
              _saveSelections(controller);
            },
            validator: (value) {
              if ((value == null || value.isEmpty) &&
                  widget.origin == DropDownOrigin.receiver) {
                return TextData.receiverValidator;
              }
              return null;
            },
          ),
        );
      },
    );
  }

  void _saveSelections(NotificationProvider controller) {
    if (widget.origin == DropDownOrigin.receiver) {
      controller.setReceivers(_currentSelections);
    } else {
      controller.setMainListReceivers(_currentSelections);
    }
  }
}