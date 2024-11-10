import 'package:flutter/material.dart';

class NotesSearchBar extends StatelessWidget {

  final TextEditingController textEditingController;
  const NotesSearchBar({super.key, required this.textEditingController});

  @override
  Widget build(BuildContext context) {

    Color borderColor = Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.1);

    return TextField(
      controller: textEditingController,
      style: TextStyle(
          fontSize: 12.5,
          color: Theme.of(context).textTheme.bodyMedium!.color
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          size: 15,
          color: borderColor.withOpacity(0.5),
        ),
        contentPadding: EdgeInsets.only(left: 5, right: 5),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
              color: borderColor,
              style: BorderStyle.solid,
              width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
              color: borderColor,
              style: BorderStyle.solid,
              width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              style: BorderStyle.solid,
              width: 2),
        ),
      ),
    );
  }
}
