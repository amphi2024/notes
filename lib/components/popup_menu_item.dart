import 'package:flutter/material.dart';

class CustomPopupMenuItem {
  static PopupMenuItem withIcon({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return PopupMenuItem(
        height: 40,
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                  color: color,
                  fontSize: 15
              ),
            ),
            Icon(
              icon,
              size: 20,
              color: color,
            )
          ],
        ));
  }

  static PopupMenuItem text({required String label, required Color color, required VoidCallback onTap, required IconData icon, required bool iconEnabled}) {
    return PopupMenuItem(
      height: 40,
      onTap: onTap,
      child: iconEnabled ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                  color: color,
                  fontSize: 15
              ),
            ),
            Icon(
               icon,
              size: 20,
              color: color,
            )
          ] ):
      Text(
        label,
        style: TextStyle(
            color: color,
            fontSize: 15
        ),
      )
      ,
    );
  }

  static PopupMenuItem title({required String label, required Color color}) {
    return PopupMenuItem(
      height: 25,
      enabled: false,
      child: Text(label,
          style: TextStyle(
              color: color,
              fontSize: 12
          )
      ),
    );
  }
}