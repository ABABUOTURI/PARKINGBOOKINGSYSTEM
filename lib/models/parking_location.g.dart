// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parking_location.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParkingLocationAdapter extends TypeAdapter<ParkingLocation> {
  @override
  final int typeId = 1;

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
      status: fields[3] as String,
      price: fields[4] as double,
      latitude: fields[5] as double,
      longitude: fields[6] as double,
      pricePerHour: fields[7] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ParkingLocation obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.latitude)
      ..writeByte(6)
      ..write(obj.longitude)
      ..writeByte(7)
      ..write(obj.pricePerHour);
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
