import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:amphi/models/app_localizations.dart';

extension DateExtension on DateTime {
  String toLocalizedString(BuildContext context) {
    return DateFormat.yMMMEd(Localizations.localeOf(context).languageCode.toString()).format(this) + "   " + DateFormat.jm("en").format(this);
  }

  String toLocalizedShortString(BuildContext context) {

    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 7) {
      return DateFormat('MM/dd/yy').format(this);
    }
    else if (difference.inDays == 1) {
      return AppLocalizations.of(context).get("@yesterday");
    } else {
      return DateFormat.jm(Localizations.localeOf(context).toString()).format(this);
    }
  }
}

DateTime parsedDateTime(String string) {
  List<String> split = string.split(";");
  return DateTime(
    int.parse(split[0]),
    int.parse(split[1]),
    int.parse(split[2]),
    int.parse(split[3]),
    int.parse(split[4]),
    int.parse(split[5]),
  );
}
