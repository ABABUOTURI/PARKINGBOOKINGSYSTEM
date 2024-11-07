// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parking_location.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParkingLocationAdapter extends TypeAdapter<ParkingLocation> {
  @override
  final int typeId = 3;

  @override
  ParkingLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ParkingLocation(
      id: fields[0] as String,
      name: fields[1] as String,
      address: fields[2] as String,
      price: fields[3] as double,
      pricePerHour: fields[4] as double?,
      status: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ParkingLocation obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.pricePerHour)
      ..writeByte(5)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParkingLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
