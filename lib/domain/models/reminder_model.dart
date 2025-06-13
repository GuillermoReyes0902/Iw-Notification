import 'package:iwproject/utils/text_data.dart';

class ReminderModel {
  String? id;
  DateTime date;
  String content;
  String senderId;
  String receiverId;
  bool completed;

  ReminderModel({
    this.id,
    required this.date,
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.completed,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
    id: json[ConstantData.reminderId] ?? '',
    date:
        DateTime.tryParse(json[ConstantData.reminderDate] ?? '') ??
        DateTime.now(),
    content: json[ConstantData.reminderContent] ?? '',
    senderId: json[ConstantData.reminderSenderId] ?? '',
    receiverId: json[ConstantData.reminderReceiverId] ?? '',
    completed: json[ConstantData.reminderCompleted] ?? false,
  );

  Map<String, dynamic> toJson() => {
    ConstantData.reminderDate: date.toIso8601String(),
    ConstantData.reminderContent: content,
    ConstantData.reminderSenderId: senderId,
    ConstantData.reminderReceiverId: receiverId,
    ConstantData.reminderCompleted: completed,
  };
}
