// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_goal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyGoalAdapter extends TypeAdapter<DailyGoal> {
  @override
  final typeId = 2;

  @override
  DailyGoal read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyGoal(
      name: fields[2] as String,
      difficulty: fields[1] as int,
    )
      .._categoryList = (fields[0] as HiveList)?.castHiveList()
      ..goals = (fields[3] as HiveList)?.castHiveList()
      ..generatedDates = (fields[4] as List)?.cast<DateTime>();
  }

  @override
  void write(BinaryWriter writer, DailyGoal obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj._categoryList)
      ..writeByte(1)
      ..write(obj.difficulty)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.goals)
      ..writeByte(4)
      ..write(obj.generatedDates);
  }
}
