import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/providers/tables_provider.dart';

class TableEditButton extends ConsumerWidget {

  final String tableId;
  final int rowIndex;
  final int colIndex;
  const TableEditButton({super.key, required this.tableId, required this.rowIndex, required this.colIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
        icon: const Icon(Icons.more_horiz_outlined),
        itemBuilder: (context) {
          return [
            PopupMenuItem(child: Text(AppLocalizations.of(context).get("@editor_table_add_column_before")),
                onTap: () {
              ref.read(tablesProvider.notifier).addColumn(tableId, colIndex);
                }
                ),
            PopupMenuItem(child: Text(AppLocalizations.of(context).get("@editor_table_add_column_after")),
                onTap: () {
                  ref.read(tablesProvider.notifier).addColumn(tableId, colIndex + 1);
                }
            ),
            PopupMenuItem(
                child: Text(AppLocalizations.of(context).get("@editor_table_add_row_below")), onTap: () {
              ref.read(tablesProvider.notifier).addRow(tableId, rowIndex);
            }),
            PopupMenuItem(
                child: Text(AppLocalizations.of(context).get("@editor_table_add_row_above")), onTap: () {
              ref.read(tablesProvider.notifier).addRow(tableId, rowIndex + 1);
            }),
            PopupMenuItem(child: Text(AppLocalizations.of(context).get("@editor_table_delete_column")), onTap: () {
              ref.read(tablesProvider.notifier).removeColumn(tableId, colIndex);
            }),
            PopupMenuItem(child: Text(AppLocalizations.of(context).get("@editor_table_delete_row")), onTap: () {
              ref.read(tablesProvider.notifier).removeRow(tableId, rowIndex);
            }),
            PopupMenuItem(child: Text(AppLocalizations.of(context).get("@editor_table_clear_cell")), onTap: () {
              ref.read(tablesProvider.notifier).setValue(id: tableId, rowIndex: rowIndex, colIndex: colIndex, value: {});
            }),
          ];
        });
  }
}
