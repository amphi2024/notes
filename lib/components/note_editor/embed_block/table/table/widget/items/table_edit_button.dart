import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';

class TableEditButton extends StatelessWidget {

  final void Function() addColumnAfter;
  final void Function() addColumnBefore;
  final void Function() addRowBefore;
  final void Function() addRowAfter;
  final void Function() removeColumn;
  final void Function() removeRow;
  final void Function() clearCell;
  const TableEditButton({super.key, required this.addColumnAfter, required this.addColumnBefore, required this.addRowBefore, required this.addRowAfter, required this.removeColumn, required this.removeRow, required this.clearCell});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: const Icon(Icons.more_horiz_outlined),
        itemBuilder: (context) {
          return [
            PopupMenuItem(child: Text(AppLocalizations.of(context).get("@editor_table_add_column_before")),
                onTap: addColumnBefore),
            PopupMenuItem(child: Text(AppLocalizations.of(context).get("@editor_table_add_column_after")),
                onTap: addColumnAfter),
            PopupMenuItem(
                child: Text(AppLocalizations.of(context).get("@editor_table_add_row_below")), onTap: addRowBefore),
            PopupMenuItem(
                child: Text(AppLocalizations.of(context).get("@editor_table_add_row_above")), onTap: addRowAfter),
            PopupMenuItem(child: Text(AppLocalizations.of(context).get("@editor_table_delete_column")), onTap: removeColumn),
            PopupMenuItem(child: Text(AppLocalizations.of(context).get("@editor_table_delete_row")), onTap: removeRow),
            PopupMenuItem(child: Text(AppLocalizations.of(context).get("@editor_table_clear_cell")), onTap: clearCell),
          ];
        });
  }
}
