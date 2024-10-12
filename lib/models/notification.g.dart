// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomNotificationAdapter extends TypeAdapter<CustomNotification> {
  @override
  final int typeId = 1;

  @override
  CustomNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomNotification(
      title: fields[0] as String?,
      message: fields[1] as String?,
      date: fields[2] as String?,
      isRead: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CustomNotification obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.isRead);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
