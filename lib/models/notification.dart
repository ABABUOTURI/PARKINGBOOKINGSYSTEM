import 'package:hive/hive.dart';

part 'notification.g.dart'; // Hive will generate this adapter

@HiveType(typeId: 1)
class CustomNotification extends HiveObject {
  @HiveField(0)
  String? title;

  @HiveField(1)
  String? message;

  @HiveField(2)
  String? date;

  @HiveField(3)
  bool isRead;

  CustomNotification({
    required this.title,
    required this.message,
    required this.date,
    this.isRead = false,
  });
}
