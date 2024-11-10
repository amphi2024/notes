import 'package:flutter/material.dart';

class BottomSheetDragHandle extends StatelessWidget {

  const BottomSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 80,
            height: 3,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(5)),
          ),
        )
      ],
    );
  }
}
