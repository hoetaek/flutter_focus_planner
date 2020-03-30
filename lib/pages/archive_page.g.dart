// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_page.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModeAdapter extends TypeAdapter<Mode> {
  @override
  final typeId = 4;

  @override
  Mode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Mode.Category;
      case 1:
        return Mode.WorkList;
      case 2:
        return Mode.Daily;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, Mode obj) {
    switch (obj) {
      case Mode.Category:
        writer.writeByte(0);
        break;
      case Mode.WorkList:
        writer.writeByte(1);
        break;
      case Mode.Daily:
        writer.writeByte(2);
        break;
    }
  }
}
