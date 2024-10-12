import 'package:hive/hive.dart';

part 'user.g.dart'; // Required for Hive type adapter generation

@HiveType(typeId: 0) // Define typeId, make sure it's unique
class User extends HiveObject{
  @HiveField(0)
  String fullName;

  @HiveField(1)
  String email;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String password;

  @HiveField(4)
  String role;

  User({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
  });
}
