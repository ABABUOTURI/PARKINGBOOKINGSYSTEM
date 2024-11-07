// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VehicleAdapter extends TypeAdapter<Vehicle> {
  @override
  final int typeId = 0;

  @override
  Vehicle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vehicle(
      driverName: fields[0] as String,
      driverPhone: fields[1] as String,
      vehicleType: fields[2] as String,
      licensePlate: fields[3] as String,
      ticketID: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Vehicle obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.driverName)
      ..writeByte(1)
      ..write(obj.driverPhone)
      ..writeByte(2)
      ..write(obj.vehicleType)
      ..writeByte(3)
      ..write(obj.licensePlate)
      ..writeByte(4)
      ..write(obj.ticketID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
