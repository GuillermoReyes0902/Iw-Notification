import 'dart:convert';

ReminderModel reminderModelFromJson(String str) => ReminderModel.fromJson(json.decode(str));

String reminderModelToJson(ReminderModel data) => json.encode(data.toJson());

class ReminderModel {
    String name;
    String date;
    String content;

    ReminderModel({
        required this.name,
        required this.date,
        required this.content,
    });

    factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
        name: json["name"],
        date: json["date"],
        content: json["content"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "date": date,
        "content": content,
    };
}