// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeedbackAdapter extends TypeAdapter<Feedback> {
  @override
  final int typeId = 2;

  @override
  Feedback read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Feedback(
      rating: fields[0] as double,
      comment: fields[1] as String,
      location: fields[2] as String,
      date: fields[3] as String,
      isResolved: fields[4] as bool,
      ownerComment: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Feedback obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.rating)
      ..writeByte(1)
      ..write(obj.comment)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.isResolved)
      ..writeByte(5)
      ..write(obj.ownerComment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedbackAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
