import 'package:flutter/cupertino.dart';

abstract class ListViewItem extends StatefulWidget {
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  const ListViewItem({super.key, required this.onPressed, required this.onLongPress});
}

