class AccessRequest {
  final String userId;
  final String fcmToken;

  AccessRequest({required this.userId, required this.fcmToken});

  Map<String, dynamic> toJson() => {"userId": userId, "fcmToken": fcmToken};
}
