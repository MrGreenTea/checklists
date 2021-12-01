import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

part 'types.g.dart';

const _uuid = Uuid();

typedef ChecklistKey = dynamic;
// the keys are always dynamic because of hive
typedef ChecklistEntry = MapEntry<ChecklistKey, Checklist>;
typedef ChecklistBox = Box<Checklist>;
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

  factory ChecklistItem.fromTitle(String title) {
    return ChecklistItem(id: _uuid.v4(), title: title);
  }
}

@HiveType(typeId: 2)
class Checklist {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final List<ChecklistItem> items;

  Checklist({required this.title, required this.items});

  factory Checklist.fromTitle(String title) {
    return Checklist(title: title, items: []);
  }
}

class ChecklistNotifier extends StateNotifier<Checklist> {
  ChecklistNotifier(Checklist state) : super(state);

  void resetAll() {
    final resetItems = state.items
        .map((e) => ChecklistItem(id: e.id, title: e.title, completed: false))
        .toList(growable: false);
    state = Checklist(title: state.title, items: resetItems);
  }

  List<ChecklistItem> get items {
    return state.items;
  }

  void setCompleted(ChecklistItemID id, bool value) {
    final newItems = state.items.map((e) {
      if (e.id == id) {
        return ChecklistItem(id: e.id, title: e.title, completed: value);
      } else {
        return e;
      }
    }).toList(growable: false);
    state = Checklist(title: state.title, items: newItems);
  }

  void addItem(String title) {
    state = Checklist(
        title: state.title,
        items: [...state.items, ChecklistItem.fromTitle(title)]);
  }
}
