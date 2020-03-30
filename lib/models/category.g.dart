// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final typeId = 0;

  @override
  Category read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      name: fields[0] as String,
    )
      .._goals = (fields[1] as HiveList)?.castHiveList()
      ..priority = fields[2] as int
      ..colorIndex = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj._goals)
      ..writeByte(2)
      ..write(obj.priority)
      ..writeByte(3)
      ..write(obj.colorIndex);
  }
}
