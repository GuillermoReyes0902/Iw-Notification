import 'package:iwproject/utils/data.dart';

class UserModel {
  String id;
  String name;
  String photo;
  List<String> fcmTokens;

  UserModel({
    required this.id,
    required this.name,
    required this.photo,
    required this.fcmTokens,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json[ConstantData.userId] ?? '',
    name: json[ConstantData.userName] ?? '',
    fcmTokens: json[ConstantData.fcmTokens] != null
        ? List<String>.from(json[ConstantData.fcmTokens])
        : [],
    photo: "assets/iwers/${json[ConstantData.userId]}.jpg",
  );
}
