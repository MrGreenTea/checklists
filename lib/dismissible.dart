import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteDismissible extends StatelessWidget {
  final Widget child;
  final DismissDirectionCallback onDismissed;
  const DeleteDismissible(
      {required Key key, required this.child, required this.onDismissed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        background: Container(
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Icon(Icons.delete, color: Colors.white),
                Text('Delete', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(Icons.delete, color: Colors.white),
                Text('Delete', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        onDismissed: onDismissed,
        key: ValueKey(key),
        child: child);
  }
}
