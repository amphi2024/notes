import 'package:flutter/material.dart';

class TitledWidget extends StatelessWidget {
  final String title;
  final Widget widget;
  const TitledWidget({super.key, required this.title, required this.widget});

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
        widget
      ],
    );
  }
}
