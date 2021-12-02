import 'package:checklists/providers.dart';
import 'package:checklists/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'checklist.dart';
import 'dismissible.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Lists'),
      ),
      body: const AllChecklists(),
      floatingActionButton: const AddChecklistButton(),
    );
  }
}

class AddChecklistDialog extends HookConsumerWidget {
  const AddChecklistDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = useState<String>("");
    return SimpleDialog(
      children: [
        TextFormField(
          onChanged: (value) => title.value = value,
        ),
        ElevatedButton(
            onPressed: () {
              final newChecklist = Checklist.fromTitle(title.value);
              ref.read(checklistsBoxProvider).add(newChecklist);
              Navigator.pop(context);
            },
            child: const Text("Add"))
      ],
    );
  }
}

class AddChecklistButton extends StatelessWidget {
  const AddChecklistButton({Key? key}) : super(key: key);

  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => const AddChecklistDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.of(context).restorablePush(_dialogBuilder),
      child: const Icon(Icons.add),
    );
  }
}

class AllChecklists extends ConsumerWidget {
  const AllChecklists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final box = ref.watch(checklistsBoxProvider);
    final checklistEntries =
        ref.watch(checklistsEntryProvider).toList(growable: false);

    return ListView.separated(
      itemCount: checklistEntries.length,
      itemBuilder: (BuildContext context, int index) {
        final listEntry = checklistEntries[index];
        return DeleteDismissible(
            onDismissed: (_) => box.delete(listEntry.key),
            key: ValueKey(listEntry.key),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ChecklistTile(entry: listEntry),
            ));
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 2,
        thickness: 2,
      ),
    );
  }
}

class ChecklistTile extends ConsumerWidget {
  final ChecklistEntry entry;

  const ChecklistTile({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final box = ref.watch(checklistsBoxProvider);
    final checklist = entry.value;

    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProviderScope(
                  child: const ChecklistPage(),
                  overrides: [
                    // set the open checklist value for the open page
                    openChecklistProvider
                        .overrideWithValue(makeNotifier(entry, box))
                  ],
                )),
      ),
      title: Text(checklist.title),
      leading: ChecklistProgress(value: checklist.progress),
      trailing: Wrap(
        spacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            "${checklist.completedCount} / ${checklist.items.length}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          const Icon(
            Icons.navigate_next,
          ),
        ],
      ),
    );
  }
}

class ChecklistProgress extends StatelessWidget {
  final double value;

  const ChecklistProgress({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: 5.0,
      backgroundColor: Colors.blueGrey.shade50,
      value: value,
    );
  }
}
