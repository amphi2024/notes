import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/note_editor/embed_block/table/note_table_view.dart';
import 'package:notes/providers/tables_provider.dart';

class EditTablePage extends ConsumerWidget {

  final String tableId;
  const EditTablePage({super.key, required this.tableId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final historyIndex = ref.watch(tablesProvider)[tableId]!.index;
    final history = ref.watch(tablesProvider)[tableId]!.history;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new)),
        actions: [
          IconButton(onPressed: () {
            ref.read(tablesProvider.notifier).undo(tableId);
          }, icon: Icon(Icons.undo, color: historyIndex > 0 ? null : Theme.of(context).disabledColor)),
          IconButton(onPressed: () {
            ref.read(tablesProvider.notifier).redo(tableId);
          }, icon: Icon(Icons.redo, color: history.length - 1 != historyIndex ? null : Theme.of(context).disabledColor))
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: MediaQuery.of(context).padding.bottom),
            child: NoteTableView(tableId: tableId, readOnly: false),
          ),
        ),
      ),
    );
  }
}
