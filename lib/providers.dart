import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'types.dart';

final checklistsBoxProvider = Provider<ChecklistBox>((_) {
  return Hive.box("checklists");
});

final checklistsEventProvider = StreamProvider((ref) {
  final box = ref.watch(checklistsBoxProvider);
  return box.watch();
});

final checklistsProvider = Provider<Map<dynamic, Checklist>>((ref) {
  final box = ref.watch(checklistsBoxProvider);
  // trigger recalc on change events
  ref.watch(checklistsEventProvider);
  return box.toMap();
});

final checklistsEntryProvider = Provider<Iterable<ChecklistEntry>>((ref) {
  return ref.watch(checklistsProvider).entries;
});

final openChecklistProvider =
    StateNotifierProvider<ChecklistNotifier, Checklist>((ref) {
  throw StateError("Can only be accessed inside checklist page");
});

ChecklistNotifier makeNotifier(ChecklistEntry entry, ChecklistBox box) {
  final notifier = ChecklistNotifier(entry.value);
  notifier.addListener((state) {
    box.put(entry.key, state);
  });
  return notifier;
}
