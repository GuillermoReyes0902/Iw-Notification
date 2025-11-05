import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/project_model.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:iwproject/utils/text_data.dart';
import 'package:provider/provider.dart';

class ProjectsDropdown extends StatefulWidget {
  const ProjectsDropdown({super.key});

  @override
  State<ProjectsDropdown> createState() => _ProjectsDropdownState();
}

class _ProjectsDropdownState extends State<ProjectsDropdown> {
  static const String _addProjectId = '__add_project__';
  final _dropdownKey = GlobalKey<DropdownSearchState<ProjectModel>>();

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, controller, _) {
        final items = [
          ...controller.projects,
          ProjectModel(id: _addProjectId, name: TextData.addProjectOption),
        ];

        return DropdownSearch<ProjectModel>(
          key: _dropdownKey,
          items: items,
          selectedItem: controller.selectedProject,
          itemAsString: (project) => project.name,
          compareFn: (a, b) => a.id == b.id,
          clearButtonProps: const ClearButtonProps(isVisible: true),
          popupProps: PopupProps.menu(
            showSelectedItems: true,
            fit: FlexFit.loose,
            constraints: const BoxConstraints(maxHeight: 320),
            menuProps: const MenuProps(),
            itemBuilder: (context, item, isSelected) {
              final isAddItem = item.id == _addProjectId;
              return ListTile(
                visualDensity: VisualDensity.compact,
                leading: isAddItem
                    ? const Icon(Icons.add, color: Colors.grey)
                    : null,
                title: Text(
                  item.name,
                  style: isAddItem
                      ? const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        )
                      : null,
                ),
                trailing: isSelected && !isAddItem
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
              );
            },
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: TextData.project,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          validator: (value) =>
              value == null ? TextData.projectValidator : null,
          onChanged: (project) async {
            if (project == null) return;
            if (project.id == _addProjectId) {
              _dropdownKey.currentState?.changeSelectedItem(
                controller.selectedProject,
              );
              await _showAddProjectDialog(context, controller);
              return;
            }
            controller.setProject(project);
          },
        );
      },
    );
  }

  Future<void> _showAddProjectDialog(
    BuildContext context,
    NotificationProvider controller,
  ) async {
    final projectCreated = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => _AddProjectDialog(controller: controller),
    );

    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    if (projectCreated == true) {
      messenger.showSnackBar(
        const SnackBar(content: Text(TextData.newProjectCreated)),
      );
    }
  }
}

class _AddProjectDialog extends StatefulWidget {
  final NotificationProvider controller;

  const _AddProjectDialog({required this.controller});

  @override
  State<_AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<_AddProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSaving) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    ProjectModel? newProject;
    try {
      newProject = await widget.controller.addProject(
        _nameController.text.trim(),
      );
    } catch (_) {
      newProject = null;
    }

    if (!mounted) return;
    if (newProject != null) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _isSaving = false;
        _errorMessage = TextData.newProjectError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(TextData.newProjectDialogTitle),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: TextData.newProjectFieldHint,
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? TextData.newProjectValidator
                  : null,
              onFieldSubmitted: (_) => _submit(),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(TextData.dialogCancel),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _submit,
          child: _isSaving
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text(TextData.dialogSave),
        ),
      ],
    );
  }
}
