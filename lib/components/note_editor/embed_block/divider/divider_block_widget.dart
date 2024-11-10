import 'package:amphi/widgets/color/picker/color_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/app_colors.dart';
import 'package:notes/models/app_state.dart';

class DividerBlockWidget extends StatefulWidget {

  final String dividerKey;
  final bool readOnly;
  const DividerBlockWidget({super.key, required this.readOnly, required this.dividerKey});

  @override
  State<DividerBlockWidget> createState() => _DividerBlockWidgetState();
}

class _DividerBlockWidgetState extends State<DividerBlockWidget> {

  @override
  Widget build(BuildContext context) {
    String dividerKey = widget.dividerKey;
    Color dividerColor = appState.noteEditingController.note.dividers[dividerKey] ?? Theme.of(context).dividerColor;
    Divider divider = Divider(
      color: dividerColor,
      thickness: 1,
    );
    if(widget.readOnly) {
      return divider;
    }
    else {
      return Row(
        children: [
          Expanded(child: divider),
          IconButton(
              onPressed: () {
                showAdaptiveColorPicker(
                    context: context, color: dividerColor,
                    defaultColor: Theme.of(context).dividerColor,
                    onDefaultColorTap: (color) {
                      setState(() {
                        appState.noteEditingController.note.dividers.remove(dividerKey);
                      });
                    },
                    onColorChanged: (color) {
                      setState(() {
                        appState.noteEditingController.note.dividers[dividerKey] = color;
                      });
                    },
                    colors: appColors.noteTextColors,
                    onAddColor: (color) {

                    },
                    onRemoveColor: (color) {

                    });
              }, icon: Icon(Icons.edit))
        ],
      );
    }

  }
}
