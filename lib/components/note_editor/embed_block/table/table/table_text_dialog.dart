import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';

class TableTextDialog extends StatefulWidget {

  final String text;
  const TableTextDialog({super.key, required this.text});

  @override
  State<TableTextDialog> createState() => _TableTextDialogState();
}

class _TableTextDialogState extends State<TableTextDialog> {

  late TextEditingController textEditingController = TextEditingController(text : widget.text);

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width > 600 ? 400 : null,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: textEditingController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: themeData.highlightColor
                      )
                    )
                  ),
                ),
              ),
            ),
            TextButton(child: Text(AppLocalizations.of(context).get("@editor_table_text_done")), onPressed: () {
              Navigator.pop(context, textEditingController.text);
            })
          ],
        ),
      ),
    );
  }
}
