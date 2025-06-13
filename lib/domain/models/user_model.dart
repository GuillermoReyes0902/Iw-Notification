import 'package:iwproject/utils/text_data.dart';

class UserModel {
  String id;
  String name;

  UserModel({required this.id, required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json[ConstantData.userId] ?? '',
    name: json[ConstantData.userName] ?? '',
  );
}
