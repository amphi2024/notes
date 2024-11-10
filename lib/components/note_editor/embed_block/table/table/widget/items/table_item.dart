import 'package:flutter/cupertino.dart';

abstract class TableItem extends StatelessWidget {
  final void Function(Map<String, dynamic>) onEdit;
  final void Function() addColumnAfter;
  final void Function() addColumnBefore;
  final void Function() addRowBefore;
  final void Function() addRowAfter;
  final void Function() removeColumn;
  final void Function() removeRow;
  final void Function() removeValue;

  const TableItem(
      {super.key,
        required this.addColumnAfter,
        required this.addColumnBefore,
        required this.addRowBefore,
        required this.addRowAfter,
        required this.removeColumn,
        required this.removeRow,
        required this.onEdit,
        required this.removeValue});
}