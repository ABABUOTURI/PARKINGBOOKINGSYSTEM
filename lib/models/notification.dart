import 'package:hive/hive.dart';

part 'notification.g.dart';  // Make sure this file is generated via build_runner

@HiveType(typeId: 1)
class CustomNotification {
  @HiveField(0)
  final String message;
  
  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final String type;

  CustomNotification({required this.message, required this.timestamp, required this.type});
}

