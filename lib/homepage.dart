import 'package:checklists/providers.dart';
import 'package:checklists/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'checklist.dart';

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
              ref
                  .read(checklistsBoxProvider)
                  .put(newChecklist.id, newChecklist);
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
    final checklists = ref.watch(checklistsProvider);

    return ListView(
      children: [
        for (final list in checklists)
          ChecklistTile(key: ValueKey(list.id), list: list)
      ],
    );
  }
}

class ChecklistTile extends ConsumerWidget {
  final Checklist list;

  const ChecklistTile({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        child: ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProviderScope(
                  child: const ChecklistPage(),
                  overrides: [
                    // set the open checklist value
                    openChecklistProvider
                        .overrideWithValue(ChecklistNotifier(list))
                  ],
                )),
      ),
      title: Text(list.title),
    ));
  }
}
