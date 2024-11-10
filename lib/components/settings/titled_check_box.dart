import 'package:flutter/material.dart';

class TitledCheckBox extends StatelessWidget {
  final String title;
  final bool value;
  final Function onChanged;
  const TitledCheckBox({super.key, required this.title, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: Text(
              title,
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Checkbox(
            value: value, onChanged: (value) {
          onChanged(value);
        }),
      ],
    );
  }
}
