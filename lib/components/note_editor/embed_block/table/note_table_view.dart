import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/note_editor/embed_block/table/table/note_table.dart';
import 'package:notes/dialogs/edit_table_dialog.dart';
import 'package:notes/pages/edit_table_page.dart';
import 'package:notes/providers/tables_provider.dart';
import 'package:notes/utils/screen_size.dart';

import 'calendar/note_calendar.dart';
import 'chart/note_chart.dart';

class NoteTableView extends ConsumerWidget {
  final String tableId;
  final bool readOnly;
  const NoteTableView({super.key, required this.tableId, required this.readOnly});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableData = ref.watch(tablesProvider)[tableId]!.data();
    List<Widget> children = [];
    var tableExist = false;

    for (int i = 0; i < tableData.views.length; i++) {
      final view = tableData.views[i];
      switch (view["type"]) {
        case "calendar":
        children.add(NoteCalendar(
          readOnly: readOnly,
          tableId: tableId,
          viewIndex: i
        ));
        case "chart":
          children.add(NoteChart(
              tableId: tableId,
              readOnly: readOnly,
            viewIndex: i
          ));
          break;
        case "table":
          tableExist = true;
          children.add(NoteTable(
              tableId: tableId,
              readOnly: readOnly,
            viewIndex: i,
          ));
          break;
      }
    }

    if (children.isEmpty || (!readOnly && !tableExist)) {
      children.add(NoteTable(
          tableId: tableId,
          readOnly: readOnly
      ));
    }

    if (!readOnly) {
      children.add(_AddViewButton(addView: (pageType) {
        ref.read(tablesProvider.notifier).insertView(tableId, tableData.views.length - 1, {"type": pageType});
      }));

      children.insert(0, _AddViewButton(addView: (pageType) {
        ref.read(tablesProvider.notifier).insertView(tableId, 0, {"type": pageType});
      }));
    }
    return GestureDetector(
      onTap: () {
        if(readOnly) {
          if(isDesktopOrTablet(context)) {
            showDialog(context: context, builder: (context) {
              return EditTableDialog(tableId: tableId);
            });
          }
          else {
            Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
              return EditTablePage(tableId: tableId);
            }));
          }
        }
      },
      child: Column(
        children: children,
      ),
    );
  }
}

class _AddViewButton extends StatelessWidget {

  final void Function(String) addView;

  const _AddViewButton({required this.addView});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PopupMenuButton(icon: Icon(Icons.add), itemBuilder: (context) {
        return [
          PopupMenuItem(child: Text(AppLocalizations.of(context).get("@editor_add_data_page_chart")), onTap: () {
            addView("chart");
          }),
          PopupMenuItem(child: Text(AppLocalizations.of(context).get("@editor_add_data_page_calendar")), onTap: () {
            addView("calendar");
          }),
        ];
      }),
    );
  }
}
