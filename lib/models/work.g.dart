// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkAdapter extends TypeAdapter<Work> {
  @override
  final typeId = 3;

  @override
  Work read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Work(
      difficulty: fields[2] as int,
    )
      .._categoryList = (fields[0] as HiveList)?.castHiveList()
      ..goals = (fields[1] as HiveList)?.castHiveList();
  }

  @override
  void write(BinaryWriter writer, Work obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj._categoryList)
      ..writeByte(1)
      ..write(obj.goals)
      ..writeByte(2)
      ..write(obj.difficulty);
  }
}
