import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:notes/providers/tables_provider.dart';
import '../buttons/table_edit_button.dart';

class TableDate extends ConsumerWidget {
  final String tableId;
  final DateTime dateTime;
  final bool readOnly;
  final int rowIndex;
  final int colIndex;

  const TableDate({super.key, required this.tableId, required this.dateTime, required this.readOnly, required this.rowIndex, required this.colIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (readOnly) {
      return Padding(
        padding: const EdgeInsets.all(7.5),
        child: SelectableText(DateFormat.yMMMEd(Localizations
            .localeOf(context)
            .languageCode
            .toString()).format(dateTime)),
      );
    }
    return GestureDetector(
        onTap: () async {
          DateTime? result = await showDatePicker(context: context, firstDate: DateTime(1950), lastDate: DateTime.now());
          if (result != null) {
            var map = {"date": result
                .toUtc()
                .millisecondsSinceEpoch};
            ref.read(tablesProvider.notifier).setValue(id: tableId, rowIndex: rowIndex, colIndex: colIndex, value: map);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(7.5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat.yMMMEd(Localizations
                      .localeOf(context)
                      .languageCode
                      .toString()).format(dateTime),
                  softWrap: true,
                  maxLines: 5,
                ),
              ),
              TableEditButton(tableId: tableId, rowIndex: rowIndex, colIndex: colIndex)
            ],
          ),
        ));
  }
}