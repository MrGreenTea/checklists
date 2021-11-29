// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChecklistItemAdapter extends TypeAdapter<ChecklistItem> {
  @override
  final int typeId = 1;

  @override
  ChecklistItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChecklistItem(
      id: fields[0] as String,
      title: fields[1] as String,
      completed: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ChecklistItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.completed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChecklistAdapter extends TypeAdapter<Checklist> {
  @override
  final int typeId = 2;

  @override
  Checklist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Checklist(
      id: fields[0] as String,
      title: fields[1] as String,
      state: (fields[2] as List).cast<ChecklistItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, Checklist obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.state);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ListOfChecklistsAdapter extends TypeAdapter<ListOfChecklists> {
  @override
  final int typeId = 3;

  @override
  ListOfChecklists read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListOfChecklists(
      (fields[1] as List).cast<Checklist>(),
    );
  }

  @override
  void write(BinaryWriter writer, ListOfChecklists obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.state);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListOfChecklistsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
