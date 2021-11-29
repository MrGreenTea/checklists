import 'package:flutter/foundation.dart';

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'types.freezed.dart';

part 'types.g.dart';

const _uuid = Uuid();

typedef ChecklistBox = Box<Checklist>;
typedef ChecklistID = String;
typedef ChecklistItemID = String;

@HiveType(typeId: 1)
class ChecklistItem with _$ChecklistItem {
  @HiveField(0)
  final ChecklistItemID id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final bool completed;

  const ChecklistItem({
    required this.id,
    required this.title,
    this.completed = false,
  });
}

@HiveType(typeId: 2)
class Checklist {
  @HiveField(0)
  final ChecklistID id;
  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<ChecklistItem> items;

  Checklist({required this.id, required this.title, required this.items});

  factory Checklist.fromTitle(String title) {
    return Checklist(id: _uuid.v4(), title: title, items: []);
  }
}
