import 'package:amphi/widgets/color/picker/color_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/app_colors.dart';

class AppThemeColorWidget extends StatelessWidget {

  final Color color;
  final void Function(Color) onChange;
  final Color defaultColor;
  const AppThemeColorWidget({super.key, required this.color, required this.onChange, required this.defaultColor});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {

        showAdaptiveColorPicker(
            context: context,
            color: color,
            onColorChanged: onChange,
            colors: appColors.themeColors,
            onAddColor: (color) {
              appColors.themeColors.add(color);
              appColors.save();
            },
            onRemoveColor: (color) {
              appColors.themeColors.remove(color);
              appColors.save();
            },
        defaultColor: defaultColor,
            onDefaultColorTap: onChange);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(30),
              border: Border.fromBorderSide(
                  BorderSide(
                  color: Theme.of(context).textTheme.bodyMedium!.color!,
                  width: 2
              ))
          ),
        ),
      ),
    );
  }
}
