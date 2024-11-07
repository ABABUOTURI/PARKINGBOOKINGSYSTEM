// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'your_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class YourModelAdapter extends TypeAdapter<YourModel> {
  @override
  final int typeId = 5;

  @override
  YourModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return YourModel(
      field1: fields[0] as String,
      field2: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, YourModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.field1)
      ..writeByte(1)
      ..write(obj.field2);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YourModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
