import 'package:hive/hive.dart';

part 'payment.g.dart';

@HiveType(typeId: 4) // Unique ID for the adapter
class Payment {
  @HiveField(0) // Field index for payment ID
  final String id;

  @HiveField(1) // Field index for booking date
  final String bookingDate;

  @HiveField(2) // Field index for booking time
  final String bookingTime;

  @HiveField(3) // Field index for total amount
  final double totalAmount;

  Payment({
    required this.id,
    required this.bookingDate,
    required this.bookingTime,
    required this.totalAmount,
  });
}
