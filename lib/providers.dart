import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'types.dart';

final hiveboxProvider = Provider<Box>((_) {
  throw UnimplementedError();
});

final savedChecklistProvider = Provider((ref) {
  final box = ref.watch(hiveboxProvider);
  final checklists = box.watch(key: "allChecklists");
  final checklists =
      (box.get("allChecklists", defaultValue: []) as List<dynamic>)
          .cast<Checklist>();
  return checklists;
});

final checklistsProvider =
    StateNotifierProvider<ListOfChecklists, List<Checklist>>((ref) {
  final box = ref.watch(hiveboxProvider);
  final checklists = ref.watch(savedChecklistProvider);

  final lister = ListOfChecklists(checklists);
  lister.addListener((state) => box.put("allChecklists", state));
  return lister;
});

final allChecklistIDsProvider =
    Provider((ref) => ref.watch(checklistsProvider).map((e) => e.id));

final checklistProvider =
    StateNotifierProvider.family<Checklist, List<ChecklistItem>, ChecklistID>(
        (ref, id) {
  final allChecklists = ref.watch(checklistsProvider);
  return allChecklists.firstWhere((element) => element.id == id);
});

final checklistTitleProvider = Provider.family(
    (ref, String id) => ref.watch(checklistProvider(id).notifier).title);
