class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String? reply;

  NotificationModel({required this.id, required this.title, required this.body, this.reply});
}