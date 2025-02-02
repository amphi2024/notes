import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/embed_block/table/table/table_data.dart';

class EditCalenderStyle extends StatefulWidget {

  final TableData tableData;
  final Map<String, dynamic> pageInfo;
  final void Function(void Function()) onStyleChange;
  const EditCalenderStyle({super.key, required this.tableData, required this.pageInfo, required this.onStyleChange});

  @override
  State<EditCalenderStyle> createState() => _EditCalenderStyleState();
}

class _EditCalenderStyleState extends State<EditCalenderStyle> {



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
      height: 130,
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(7.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).get("@editor_calendar_rows_to_show")),
                DropdownButton<int>(
                    value: widget.pageInfo["rowIndex"] ?? 0,
                    items: items,
                    onChanged: (item) {
                      if(item != null) {
                        setState(() {
                          widget.onStyleChange(() {
                            widget.pageInfo["rowIndex"] = item;
                          });
                        });
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
                    value: widget.pageInfo["dateRowIndex"] ?? 0,
                    items: items,
                    onChanged: (item) {
                      if(item != null) {
                        setState(() {
                          widget.onStyleChange(() {
                            widget.pageInfo["dateRowIndex"] = item;
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
