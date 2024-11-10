import 'package:flutter/material.dart';
import 'package:notes/components/settings/app_theme_color_widget.dart';

class ColorRow extends StatelessWidget {

  final String label;
  final Color lightColor;
  final Color darkColor;
  final void Function(Color) lightColorChanged;
  final void Function(Color) darkColorChanged;
  final Color defaultLightColor;
  final Color defaultDarkColor;
  const ColorRow({super.key, required this.label, required this.lightColor, required this.lightColorChanged, required this.darkColor, required this.darkColorChanged, required this.defaultLightColor, required this.defaultDarkColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label, maxLines: 3, softWrap: true,),
        ),
      AppThemeColorWidget( color: lightColor, onChange: lightColorChanged, defaultColor: defaultLightColor),
        AppThemeColorWidget(color: darkColor, onChange: darkColorChanged, defaultColor: defaultDarkColor,),
      ],
    );
  }
}
