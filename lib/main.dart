import 'package:checklists/homepage.dart';
import 'package:checklists/providers.dart';
import 'package:checklists/types.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  Hive.registerAdapter(ChecklistItemAdapter());
  Hive.registerAdapter(ChecklistAdapter());
  Hive.registerAdapter(ListOfChecklistsAdapter());
  await Hive.initFlutter();
  var box = await Hive.openBox('checklists');
  runApp(ProviderScope(
    overrides: [hiveboxProvider.overrideWithValue(box)],
    child: const ChecklistApp(),
  ));
}

class ChecklistApp extends StatelessWidget {
  const ChecklistApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Homepage(),
    );
  }
}
