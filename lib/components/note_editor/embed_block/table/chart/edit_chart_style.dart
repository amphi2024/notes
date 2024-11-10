import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/embed_block/table/table/table_data.dart';

class EditChartStyle extends StatefulWidget {
  final TableData tableData;
  final Map<String, dynamic> pageInfo;
  final void Function(void Function()) onStyleChange;
  const EditChartStyle({super.key, required this.tableData, required this.onStyleChange, required this.pageInfo});

  @override
  State<EditChartStyle> createState() => _EditChartStyleState();
}

class _EditChartStyleState extends State<EditChartStyle> {
  @override
  Widget build(BuildContext context) {

    var items = List.generate(widget.tableData.data.first.length, (index) {
      return DropdownMenuItem(
        value: index,
          child: Text((index + 1).toString())
      );
    });

    return Container(
      width: 250,
      height: 120,
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(7.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).get("@editor_chart_ascending")),
                Checkbox(value: widget.pageInfo["ascending"] ?? false, onChanged: (value) {
                 setState(() {
                   widget.onStyleChange(() {
                     widget.pageInfo["ascending"] = value;
                   });
                 });
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
                  value: widget.pageInfo["row-index"] ?? 0,
                    items: items,
                    onChanged: (item) {
                      if(item != null) {
                        setState(() {
                          widget.onStyleChange(() {
                            widget.pageInfo["row-index"] = item;
                          });
                        });
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
