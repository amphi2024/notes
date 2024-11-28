import 'package:notes/models/app_settings.dart';

extension SortExtension on List<dynamic> {

  void sortByOption() {
    switch (appSettings.sortBy) {
      case "title":
        sortByTitle();
        break;
      case "created":
        sortByCreatedDate();
        break;
      case "modified":
        sortByModifiedDate();
        break;
    }
  }

  void sortByTitle() {
    if(appSettings.descending) {
      sort((a, b) {
        return b.title.compareTo(a.title);
      });
    }
    else {
      sort((a, b) {
        return a.title.compareTo(b.title);
      });
    }
  }

  void sortByCreatedDate() {
    if(appSettings.descending) {
      sort((a, b) {
        return a.created.compareTo(b.created);
      });
    }
    else {
      sort((a, b) {
        return b.created.compareTo(a.created);
      });
    }
  }
  void sortByModifiedDate() {
    if(appSettings.descending) {
      sort((a, b) {
        return a.modified.compareTo(b.modified);
      });
    }
    else {
      sort((a, b) {
        return b.modified.compareTo(a.modified);
      });
    }
  }
}