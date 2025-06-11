class ReminderModel {
  String id;
  DateTime date;
  String content;
  String senderId;
  String receiverId;
  bool completed;

  ReminderModel({
    required this.id,
    required this.date,
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.completed,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
    id: json['id'] ?? '',
    date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
    content: json['content'] ?? '',
    senderId: json['senderId'] ?? '',
    receiverId: json['receiverId'] ?? '',
    completed: json['completed'] ?? false,
  );
}
