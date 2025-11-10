import 'package:iwproject/utils/data.dart';
import 'package:iwproject/utils/text_data.dart';

class ReminderModel {
  String? id;
  DateTime date;
  DateTime deadline;
  String priority;
  String content;
  String senderId;
  String receiverId;
  String projectId;
  List<String> receiversIds;
  bool completed;
  String status;

  ReminderModel({
    this.id,
    required this.date,
    required this.deadline,
    required this.content,
    required this.senderId,
    required this.priority,
    required this.projectId,
    required this.receiverId,
    required this.receiversIds,
    required this.completed,
    required this.status,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
    id: json[ConstantData.reminderId],
    priority: json[ConstantData.reminderPriority] ?? TextData.priorityList[0],
    date: DateTime.tryParse(json[ConstantData.reminderDate]) ?? DateTime.now(),
    deadline:
        DateTime.tryParse(json[ConstantData.reminderDeadline]) ??
        DateTime.now(),
    content: json[ConstantData.reminderContent],
    senderId: json[ConstantData.reminderSenderId],
    projectId: json[ConstantData.reminderProjectId],
    receiverId: json[ConstantData.reminderReceiverId],
    receiversIds: (json[ConstantData.reminderReceiversIds] as List)
        .cast<String>(),
    completed: json[ConstantData.reminderCompleted] ?? false,
    status: json[ConstantData.reminderStatus],
  );

  Map<String, dynamic> toJson() => {
    ConstantData.reminderDate: date.toIso8601String(),
    ConstantData.reminderDeadline: deadline.toIso8601String(),
    ConstantData.reminderPriority: priority,
    ConstantData.reminderContent: content,
    ConstantData.reminderSenderId: senderId,
    ConstantData.reminderReceiverId: receiverId,
    ConstantData.reminderReceiversIds: receiversIds,
    ConstantData.reminderCompleted: completed,
    ConstantData.reminderProjectId: projectId,
    ConstantData.reminderStatus: status,
  };
}
