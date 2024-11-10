import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/embed_block/table/table/widget/items/table_add_button.dart';
import 'package:notes/components/note_editor/embed_block/table/table/widget/items/table_date.dart';
import 'package:notes/components/note_editor/embed_block/table/table/widget/items/table_edit_button.dart';
import 'package:notes/components/note_editor/embed_block/table/table/widget/items/table_image.dart';
import 'package:notes/components/note_editor/embed_block/table/table/widget/items/table_text.dart';
import 'package:notes/components/note_editor/embed_block/table/table/widget/items/table_video.dart';
import 'package:notes/components/note_editor/embed_block/table/table/table_data.dart';

class NoteTableBlock extends StatefulWidget{

  final TableData tableData;
  final bool readOnly;
  final Map<String, dynamic> pageInfo;
  const NoteTableBlock({super.key, required this.tableData, required this.readOnly, required this.pageInfo});

  @override
  State<NoteTableBlock> createState() => _NoteTableBlockState();
}

class _NoteTableBlockState extends State<NoteTableBlock> {

  void addColumn(int index) {
    setState(() {
      for (int j = 0; j < widget.tableData.data.length; j++) {
        widget.tableData.data[j].insert(index, {"text": ""});
      }
    });
  }

  void addRow(int index) {
    setState(() {
      List<Map<String, dynamic>> list =
          List.filled(widget.tableData.data.first.length, {"text": ""}, growable: true);
      widget.tableData.data.insert(index, list);
    });
  }

  void removeRow(int index) {
    setState(() {
      widget.tableData.data.removeAt(index);
    });
  }

  void removeColumn(int index) {
    setState(() {
      for (int j = 0; j < widget.tableData.data.length; j++) {
        widget.tableData.data[j].removeAt(index);
      }
    });
  }

  void removeValue(int rowIndex, int colIndex) {
    setState(() {
      widget.tableData.data[rowIndex][colIndex] = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    List<TableRow> rows = [];
    for (int j = 0; j < widget.tableData.data.length; j++) {
      List<TableCell> tableCells = [];
      for (int i = 0; i < widget.tableData.data[j].length; i++) {
        Map<String, dynamic> data = widget.tableData.data[j][i];
        if (data["img"] != null) {
          tableCells.add(TableCell(
              child: TableImage(
                  filename: data["img"]!,
                  addColumnAfter: () => addColumn(i + 1),
                  addColumnBefore: () => addColumn(i),
                  addRowAfter: () => addRow(j + 1),
                  addRowBefore: () => addRow(j),
                  removeColumn: () => removeColumn(i),
                  removeRow: () => removeRow(j),
                  removeValue: () => removeValue(j, i))));
        } else if (data["video"] != null) {
          tableCells.add(TableCell(
              child: TableVideo(
                  filename: data["video"]!,
                  addColumnAfter: () => addColumn(i + 1),
                  addColumnBefore: () => addColumn(i),
                  addRowAfter: () => addRow(j + 1),
                  addRowBefore: () => addRow(j),
                  removeColumn: () => removeColumn(i),
                  removeRow: () => removeRow(j),
                  removeValue: () => removeValue(j, i))));
        } else if (data["date"] != null) {
          tableCells.add(TableCell(
              child: TableDate(
            onEdit: (edited) {
              setState(() {
                widget.tableData.data[j][i] = edited;
              });
            },
            date: data["date"]!,
            addColumnAfter: () => addColumn(i + 1),
            addColumnBefore: () => addColumn(i),
            addRowAfter: () => addRow(j + 1),
            addRowBefore: () => addRow(j),
            removeColumn: () => removeColumn(i),
            removeRow: () => removeRow(j),
            removeValue: () => removeValue(j, i),
          )));
        } else if (data["text"] != null && data["text"].toString().isNotEmpty) {
          tableCells.add(TableCell(
              child: TableText(
            text: data["text"]!,
            onEdit: (edited) {
              setState(() {
                widget.tableData.data[j][i] = edited;
              });
            },
            addColumnAfter: () => addColumn(i + 1),
            addColumnBefore: () => addColumn(i),
            addRowAfter: () => addRow(j + 1),
            addRowBefore: () => addRow(j),
            removeColumn: () => removeColumn(i),
            removeRow: () => removeRow(j),
            removeValue: () => removeValue(j, i),
          )));
        } else {
          if (widget.readOnly) {
            tableCells.add(TableCell(child: Text("")));
          } else {
            tableCells.add(TableCell(
                child: Row(
              children: [
                TableAddButton(
                    onEdit: ( edited) {
                      setState(() {
                        widget.tableData.data[j][i] = edited;
                      });
                    },
                    addColumnAfter: () => addColumn(i + 1),
                    addColumnBefore: () => addColumn(i),
                    addRowAfter: () => addRow(j + 1),
                    addRowBefore: () => addRow(j),
                    removeColumn: () => removeColumn(i),
                    removeRow: () => removeRow(j)),
                TableEditButton(
                    addColumnAfter: () => addColumn(i + 1),
                    addColumnBefore: () => addColumn(i),
                    addRowAfter: () => addRow(j + 1),
                    addRowBefore: () => addRow(j),
                    removeColumn: () => removeColumn(i),
                    removeRow: () => removeRow(j),
                    clearCell: () => removeValue(j, i))
              ],
            )));
          }
        }
      }
      rows.add(TableRow(children: tableCells));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Table(
            border: TableBorder.all(color: Theme.of(context).textTheme.bodyMedium!.color!, width: 1),
            //  defaultColumnWidth: MaxColumnWidth(FixedColumnWidth(100), FixedColumnWidth(250)),
            children: rows,
          )
        ],
      ),
    );
  }
}
