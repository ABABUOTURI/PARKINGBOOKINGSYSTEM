import 'package:hive/hive.dart';

part 'your_model.g.dart'; // Hive will generate this file

@HiveType(typeId: 0) // Use unique type IDs for each model
class YourModel {
  @HiveField(0)
  final String field1;

  @HiveField(1)
  final int field2;

  YourModel({required this.field1, required this.field2});
}
