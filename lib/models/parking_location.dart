import 'package:hive/hive.dart';

part 'parking_location.g.dart'; // This will be generated by Hive

@HiveType(typeId: 3) // Unique ID for the adapter
class ParkingLocation extends HiveObject {
  @HiveField(0) // Field index for ID
  final String id;

  @HiveField(1) // Field index for name
  final String name;

  @HiveField(2) // Field index for address
  final String address;

  @HiveField(3) // Field index for price
  final double price; // Price as a double

  @HiveField(4) // Field index for pricePerHour
  final double? pricePerHour;

  @HiveField(5) // Field index for status
  late final String status; // Status of parking (Occupied/Available)

  ParkingLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.price,
    this.pricePerHour,
    required this.status,
  });
}
