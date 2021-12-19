import 'package:checklists/providers.dart';
import 'package:checklists/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'dismissible.dart';

class ChecklistPage extends ConsumerWidget {
  const ChecklistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const ChecklistTitle(),
        actions: const [ResetAllButton()],
      ),
      body: const ChecklistItems(),
      floatingActionButton: const AddChecklistItemButton(),
    );
  }
}

class ChecklistTitle extends ConsumerWidget {
  const ChecklistTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(openChecklistProvider.select((lst) => lst.title));
    return Text(title);
  }
}

class ResetAllButton extends ConsumerWidget {
  const ResetAllButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () => ref.read(openChecklistProvider.notifier).resetAll(),
      icon: const Icon(
        Icons.restart_alt,
      ),
      tooltip: 'Reset all',
    );
  }
}

class ChecklistItems extends HookConsumerWidget {
  const ChecklistItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(openChecklistProvider);
    final notifier = ref.watch(openChecklistProvider.notifier);
    useEffect(() {
      final removeListener = notifier.addListener((state) {
        if (state.items.isNotEmpty && state.isFinished) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Checklist Complete!"),
                content: const Text('Would you like to uncheck the checklist?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      notifier.resetAll();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }, fireImmediately: false);
      return removeListener;
    });

    return ReorderableListView(
      onReorder: (int oldIndex, int newIndex) =>
          notifier.moveItem(oldIndex, newIndex),
      children: [
        for (final item in list.items)
          DeleteDismissible(
            onDismissed: (_) => notifier.removeItem(item.id),
            key: ValueKey(item.id),
            child: ChecklistItemTile(
              item: item,
            ),
          )
      ],
    );
  }
}

class ChecklistItemTile extends ConsumerWidget {
  final ChecklistItem item;
  const ChecklistItemTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onChanged(bool? value) => ref
        .read(openChecklistProvider.notifier)
        .setCompleted(item.id, value ?? false);

    return Card(
      child: CheckboxListTile(
        value: item.completed,
        title: Text(item.title),
        onChanged: onChanged,
      ),
    );
  }
}

class AddItemDialog extends HookConsumerWidget {
  final void Function(String) onAdd;

  const AddItemDialog(this.onAdd, {Key? key}) : super(key: key);

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
          onPressed: () => onAdd(title.value),
          child: const Text("Add"),
        )
      ],
    );
  }
}

class AddChecklistItemButton extends ConsumerWidget {
  const AddChecklistItemButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onAdd(String title) {
      ref.read(openChecklistProvider.notifier).addItem(title);
      Navigator.pop(context);
    }

    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () =>
          showDialog(context: context, builder: (_) => AddItemDialog(onAdd)),
    );
  }
}
