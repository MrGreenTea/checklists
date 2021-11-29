import 'package:checklists/providers.dart';
import 'package:checklists/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChecklistPage extends ConsumerWidget {
  final ChecklistID id;
  const ChecklistPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklist = ref.watch(checklistProvider(id).notifier);
    final title = ref.watch(checklistTitleProvider(id));
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [ResetAllButton(list: checklist)],
      ),
      body: ChecklistItems(list: checklist),
      floatingActionButton: AddChecklistItemButton(list: checklist),
    );
  }
}

class ResetAllButton extends StatelessWidget {
  final Checklist list;

  const ResetAllButton({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => list.resetAll(),
        icon: const Icon(
          Icons.restart_alt,
        ),
        tooltip: 'Reset all');
  }
}

class ChecklistItems extends ConsumerWidget {
  final Checklist list;
  const ChecklistItems({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(checklistProvider(list.id));
    return ListView(
      children: [
        for (final item in items)
          ChecklistItemTile(
            value: item.completed,
            title: item.title,
            onChanged: (value) => list.setCompleted(item.id, value ?? false),
          )
      ],
    );
  }
}

class ChecklistItemTile extends HookWidget {
  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;
  const ChecklistItemTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        value: value,
        title: Text(title),
        onChanged: onChanged,
      ),
    );
  }
}

class AddItemDialog extends HookConsumerWidget {
  final Checklist list;
  const AddItemDialog({Key? key, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = useState<String>("");
    return AlertDialog(
      title: const Text("New Item"),
      content: TextFormField(
        initialValue: title.value,
        onChanged: (value) => title.value = value,
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              list.add(title.value);
              Navigator.pop(context);
            },
            child: const Text("Add"))
      ],
    );
  }
}

class AddChecklistItemButton extends StatelessWidget {
  final Checklist list;
  const AddChecklistItemButton({Key? key, required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => showDialog(
          context: context, builder: (_) => AddItemDialog(list: list)),
      child: const Icon(Icons.add),
    );
  }
}
