import 'package:flutter/material.dart';

class DividerBlockWidget extends StatelessWidget {

  final int? colorValue;
  final bool readOnly;
  const DividerBlockWidget({super.key, required this.readOnly, required this.colorValue});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement divider color change in a future version.
    return Divider(
      color: colorValue == null ? Theme.of(context).dividerColor : Color(colorValue!),
      thickness: 1,
      height: 5,
    );
  }
}
