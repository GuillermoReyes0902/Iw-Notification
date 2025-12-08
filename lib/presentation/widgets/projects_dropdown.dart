import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:iwproject/domain/models/project_model.dart';
import 'package:iwproject/presentation/providers/notification_provider.dart';
import 'package:iwproject/utils/data.dart';

import 'package:iwproject/utils/text_data.dart';
import 'package:provider/provider.dart';

class ProjectsDropdown extends StatefulWidget {
  const ProjectsDropdown({super.key});

  @override
  State<ProjectsDropdown> createState() => _ProjectsDropdownState();
}

class _ProjectsDropdownState extends State<ProjectsDropdown> {
  final _dropdownKey = GlobalKey<DropdownSearchState<ProjectModel>>();

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, controller, _) {
        // --- Construimos la lista dependiendo del origen ---
        List<ProjectModel> items = [];

        items = [
          ...controller.projects,
          ProjectModel(
            id: ConstantData.addProjectId,
            name: TextData.addProjectOption,
          ), // "Añadir proyecto"
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
              final isAddItem = item.id == ConstantData.addProjectId;
              final isAllItem = item.id == ConstantData.allProjectsId;

              return ListTile(
                visualDensity: VisualDensity.compact,
                leading: isAddItem
                    ? const Icon(Icons.add, color: Colors.grey)
                    : isAllItem
                    ? const Icon(Icons.apps, color: Colors.blueGrey)
                    : null,
                title: Text(
                  item.name,
                  style: isAddItem || isAllItem
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
            if (project.id == ConstantData.addProjectId) {
              // Caso: añadir nuevo proyecto
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

class BasicProjectDropdown extends StatelessWidget {
  const BasicProjectDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, controller, _) {
        final List<DropdownMenuItem<ProjectModel>> items = [];
        items.add(
          DropdownMenuItem<ProjectModel>(
            value: null,
            child: Row(
              children: [
                Icon(
                  Icons.apps,
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
          controller.projects.map(
            (project) => DropdownMenuItem<ProjectModel>(
              value: project,
              child: SizedBox(
                width: 250, // ajusta el ancho máximo del texto
                child: Text(
                  project.name,
                  style: TextStyle(
                    fontSize: Platform.isWindows || Platform.isMacOS ? 12 : 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ),
        );

        return SizedBox(
          height: Platform.isWindows || Platform.isMacOS ? 45 : 50,
          child: DropdownButtonFormField<ProjectModel>(
            iconEnabledColor: Colors.grey[400]!,
            value: controller.selectedProject,
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
            onChanged: (value) => controller.setMainListProject(value),
            validator: (value) => null,
          ),
        );
      },
    );
  }
}
