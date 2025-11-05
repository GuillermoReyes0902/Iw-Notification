import 'package:iwproject/utils/text_data.dart';

class ProjectModel {
  String id;
  String name;

  ProjectModel({required this.id, required this.name});

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    id: json[ConstantData.projectId] ?? '',
    name: json[ConstantData.projectName] ?? '',
  );
}
