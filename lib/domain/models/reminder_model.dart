class ReminderModel {
  String id;
  String name;
  DateTime date;
  String content;

  ReminderModel({
    required this.id,
    required this.name,
    required this.date,
    required this.content,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) => ReminderModel(
    id: json["id"],
    name: json["name"],
    date: DateTime.parse(json["date"]),
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "date": date,
    "content": content,
  };
}
