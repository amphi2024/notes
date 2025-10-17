import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/note_editor/embed_block/table/note_table_view.dart';
import '../providers/tables_provider.dart';

class EditTableDialog extends ConsumerWidget {
  final String tableId;
  const EditTableDialog({super.key, required this.tableId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyIndex = ref.watch(tablesProvider)[tableId]!.index;
    final history = ref.watch(tablesProvider)[tableId]!.history;

    return Dialog(
      child: SizedBox(
        width: 450,
        height: 250,
        child: Column(
          children: [
            Positioned(
                left: 0,
                top: 0,
                child: IconButton(onPressed: () {
              Navigator.pop(context);
            }, icon: Icon(Icons.cancel_outlined))),
            Positioned(
                right: 0,
                top: 0,
                child: Row(
                  children: [
                    IconButton(onPressed: () {
                      ref.read(tablesProvider.notifier).undo(tableId);
                    }, icon: Icon(Icons.undo, color: historyIndex > 0 ? null : Theme.of(context).disabledColor)),
                    IconButton(onPressed: () {
                      ref.read(tablesProvider.notifier).redo(tableId);
                    }, icon: Icon(Icons.redo, color: history.length - 1 != historyIndex ? null : Theme.of(context).disabledColor))
                  ],
                )),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 50,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: MediaQuery.of(context).padding.bottom),
                  child: NoteTableView(tableId: tableId, readOnly: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
