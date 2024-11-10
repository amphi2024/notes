import 'package:flutter/material.dart';
import 'package:notes/models/app_theme.dart';

class ToggleAttributeButton extends StatelessWidget {
  final bool activated;
  final IconData icon;
  final VoidCallback onPressed;

  const ToggleAttributeButton(
      {super.key,
      required this.activated,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Color accentColor = Theme.of(context).colorScheme.primary;
    Color noteBackgroundColor = Theme.of(context).colorScheme.surface;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: 40,
        height: 40,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                backgroundColor: activated
                    ? accentColor
                    : noteBackgroundColor,
              disabledForegroundColor: AppTheme.transparent,
               disabledBackgroundColor: AppTheme.transparent,
               surfaceTintColor: AppTheme.transparent,
              foregroundColor: AppTheme.transparent,
              shadowColor: AppTheme.transparent
            ),
            onPressed: onPressed,
            child: Icon(
              icon,
              color:
                  activated ? noteBackgroundColor : accentColor,
            )),
      ),
    );
  }
}
