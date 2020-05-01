// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalAdapter extends TypeAdapter<Goal> {
  @override
  final typeId = 1;

  @override
  Goal read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Goal(
      name: fields[0] as String,
      difficulty: fields[1] as int,
      status: fields[2] as String,
    )
      ..checked = fields[3] as bool
      ..date = fields[4] as DateTime
      .._categoryList = (fields[5] as HiveList)?.castHiveList()
      .._workList = (fields[6] as HiveList)?.castHiveList()
      .._inProgress = fields[7] as bool
      .._specificGoals = (fields[8] as List)?.cast<String>();
  }

  @override
  void write(BinaryWriter writer, Goal obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.difficulty)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.checked)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj._categoryList)
      ..writeByte(6)
      ..write(obj._workList)
      ..writeByte(7)
      ..write(obj._inProgress)
      ..writeByte(8)
      ..write(obj._specificGoals);
  }
}
