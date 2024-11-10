import 'package:flutter/cupertino.dart';
import 'package:notes/models/app_theme.dart';

class DurationWidget extends StatelessWidget {

  final Duration duration;
  const DurationWidget({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Text(
        duration.toTimeString(),
      style: const TextStyle(
        color: AppTheme.white,
        fontSize: 13
      ),
    );
  }
}

extension DurationdExtension on Duration{
  String toTimeString() {
    if(inHours > 0) {
      int hours = inHours;
     int minutes = inMinutes - hours * 60;
     int seconds = inSeconds - minutes * 60;
      return "$hours:$minutes:$seconds";
    }
    else {
      int minutes = inMinutes;
      int seconds = inSeconds - minutes * 60;
      if(seconds < 10) {
        return "$minutes:0$seconds";
      }
      else {
        return "$minutes:$seconds";
      }
    }

  }
}