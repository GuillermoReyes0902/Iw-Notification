import 'package:iwproject/utils/text_data.dart';

class UserModel {
  String id;
  String name;
  String photo;

  UserModel({required this.id, required this.name, required this.photo});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json[ConstantData.userId] ?? '',
    name: json[ConstantData.userName] ?? '',
    photo: "assets/iwers/${json[ConstantData.userId]}.jpg",
  );
}
