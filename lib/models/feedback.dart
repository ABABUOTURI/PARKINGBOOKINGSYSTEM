import 'package:hive/hive.dart';

part 'feedback.g.dart'; // Make sure to generate this file

@HiveType(typeId: 2) // Unique ID for the adapter
class Feedback extends HiveObject {
  @HiveField(0)
  final double rating; // Rating given by the user

  @HiveField(1)
  final String comment; // Comments provided by the user

  @HiveField(2)
  final String location; // Parking location selected

  @HiveField(3)
  final String date; // Date of feedback submission

  @HiveField(4)
  bool isResolved; // Status of feedback resolution

  @HiveField(5)
  String ownerComment; // Comment by the parking owner based on feedback

  Feedback({
    required this.rating,
    required this.comment,
    required this.location,
    required this.date,
    this.isResolved = false, // Default value for isResolved
    this.ownerComment = '', // Default empty value for ownerComment
  });
}
