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
              ref
                  .read(checklistsProvider.notifier)
                  .createChecklist(title.value);
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
    final checklistIDs = ref.watch(allChecklistIDsProvider);
    return ListView(
      children: [for (final id in checklistIDs) ChecklistTile(id: id)],
    );
  }
}

class ChecklistTile extends ConsumerWidget {
  final ChecklistID id;

  const ChecklistTile({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(checklistTitleProvider(id));
    return Card(
        child: ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChecklistPage(id: id)),
      ),
      title: Text(title),
    ));
  }
}
