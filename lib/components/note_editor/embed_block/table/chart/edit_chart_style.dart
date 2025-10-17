import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/providers/tables_provider.dart';

class EditChartStyle extends ConsumerWidget {
  final int viewIndex;
  final String tableId;
  const EditChartStyle({super.key, required this.tableId, required this.viewIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableData = ref.watch(tablesProvider)[tableId]!.data();
    final viewInfo = tableData.views[viewIndex];
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
                Text(AppLocalizations.of(context).get("@editor_chart_ascending")),
                Checkbox(value: viewInfo["ascending"] ?? false, onChanged: (value) {
                  ref.read(tablesProvider.notifier).updateView(tableId, viewIndex, "ascending", value);
                })
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).get("@editor_chart_rows_to_show")),
                DropdownButton<int>(
                    value: viewInfo["rowIndex"] ?? 0,
                    items: items,
                    onChanged: (item) {
                      if (item != null) {
                        ref.read(tablesProvider.notifier).updateView(tableId, viewIndex, "rowIndex", item);
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
