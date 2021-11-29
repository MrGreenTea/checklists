import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'types.dart';

final checklistsBoxProvider = Provider<ChecklistBox>((_) {
  throw UnimplementedError();
});

final checklistsEventProvider = StreamProvider((ref) {
  final box = ref.watch(checklistsBoxProvider);
  return box.watch();
});

final checklistsProvider = Provider((ref) {
  final box = ref.watch(checklistsBoxProvider);
  // so we trigger a new value on every event
  ref.watch(checklistsEventProvider);
  return box.values;
});

final allChecklistIDsProvider = Provider((ref) {
  return ref.watch(checklistsProvider).map((e) => e.id);
});

final checklistEventProvider =
    StreamProvider.family<BoxEvent, String>((ref, id) {
  final box = ref.watch(checklistsBoxProvider);
  return box.watch(key: id);
});

final checklistProvider =
    StateNotifierProvider.family<Checklist, List<ChecklistItem>, ChecklistID>(
        (ref, id) {
  final box = ref.watch(checklistsBoxProvider);
  ref.watch(checklistEventProvider(id));
  return box.get(id);
});

final checklistTitleProvider = Provider.family(
    (ref, String id) => ref.watch(checklistProvider(id).notifier).title);
