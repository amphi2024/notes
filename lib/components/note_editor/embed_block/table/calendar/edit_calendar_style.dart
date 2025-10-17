import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/providers/tables_provider.dart';

class EditCalenderStyle extends ConsumerWidget {
  final String tableId;
  final int viewIndex;

  const EditCalenderStyle({super.key, required this.viewIndex, required this.tableId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableData = ref.watch(tablesProvider)[tableId]!.data();

    final items = List.generate(tableData.data.first.length, (index) {
      return DropdownMenuItem(
          value: index,
          child: Text((index + 1).toString())
      );
    });

    return Container(
      width: 250,
      height: 130,
      decoration: BoxDecoration(color: Theme
          .of(context)
          .cardColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(7.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).get("@editor_calendar_rows_to_show")),
                DropdownButton<int>(
                    value: tableData.views[viewIndex]["rowIndex"] ?? 0,
                    items: items,
                    onChanged: (item) {
                      if (item != null) {
                        ref.read(tablesProvider.notifier).updateView(tableId, viewIndex, "rowIndex", item);
                      }
                    })
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).get("@editor_calendar_rows_for_date")),
                DropdownButton<int>(
                    value: tableData.views[viewIndex]["dateRowIndex"] ?? 0,
                    items: items,
                    onChanged: (item) {
                      if (item != null) {
                        ref.read(tablesProvider.notifier).updateView(tableId, viewIndex, "dateRowIndex", item);
                      }
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
