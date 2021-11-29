import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

part 'types.g.dart';

const _uuid = Uuid();

typedef ChecklistID = String;
typedef ChecklistItemID = String;

@HiveType(typeId: 1)
class ChecklistItem {
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

  Map<String, dynamic> toJson() {
    return {"title": title, "id": id, "completed": completed};
  }

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
        id: json["id"],
        title: json["title"],
        completed: json["completed"] ?? false);
  }
}

@HiveType(typeId: 2)
class Checklist extends StateNotifier<List<ChecklistItem>> {
  @HiveField(0)
  final ChecklistID id;
  @HiveField(1)
  final String title;

  @HiveField(2)
  @override
  final List<ChecklistItem> state;

  Checklist({required this.id, required this.title, required this.state})
      : super(state);

  void add(String title) {
    state = [...state, ChecklistItem(id: _uuid.v4(), title: title)];
  }

  void resetAll() {
    state = state
        .map((e) => ChecklistItem(id: e.id, title: e.title, completed: false))
        .toList(growable: false);
  }

  void toggle(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          ChecklistItem(
              id: item.id, title: item.title, completed: !item.completed)
        else
          item
    ];
  }

  void setCompleted(String id, bool value) {
    state = [
      for (final item in state)
        if (item.id == id)
          ChecklistItem(id: item.id, title: item.title, completed: value)
        else
          item
    ];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "items": state.map((e) => e.toJson()).toList()
    };
  }

  factory Checklist.fromJson(Map<String, dynamic> json) {
    final items = json["items"]
        .map((e) => ChecklistItem.fromJson(e))
        // the cast is mostly for when the list is empty
        // it would fail with 'List<dynamic>' is not a subtype of type 'List<ChecklistItem>'
        .toList(growable: false)
        .cast<ChecklistItem>();
    return Checklist(id: json['id'], title: json['title'], state: items);
  }
}

@HiveType(typeId: 3)
class ListOfChecklists extends StateNotifier<List<Checklist>> {
  @HiveField(1)
  @override
  final List<Checklist> state;

  ListOfChecklists(this.state) : super(state);

  void createChecklist(String title) {
    state = [...state, Checklist(id: _uuid.v4(), title: title, state: [])];
  }
}
