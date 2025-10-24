import 'package:amphi/models/app_cache_data_core.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:notes/models/sort_option.dart';

import 'app_storage.dart';

final appCacheData = AppCacheData.getInstance();

class AppCacheData extends AppCacheDataCore {
  static final AppCacheData _instance = AppCacheData();
  static AppCacheData getInstance() => _instance;

  double get sidebarWidth => data["sidebarWidth"] ?? 200;
  set sidebarWidth(value) => data["sidebarWidth"] = value;
  double get notesViewWidth => data["notesViewWidth"] ?? 250;
  set notesViewWidth(value) => data["notesViewWidth"] = value;

  String sortOption(String id) {
    var dirName = PathUtils.basename(appStorage.selectedUser.storagePath);
    if(data["sortOption"]?[dirName] is Map) {
      var option = data["sortOption"][dirName][id.isEmpty ? "!HOME" : id];
      if(option is String) {
        return option;
      }
      else {
        return SortOption.modified;
      }
    }
    else {
      data["sortOption"] = <String, dynamic>{};
      return SortOption.modified;
    }
  }

  void setSortOption({required String sortOption, required String id}) {
    var dirName = PathUtils.basename(appStorage.selectedUser.storagePath);
    if(data["sortOption"]?[dirName] is! Map) {
      data["sortOption"] = <String, dynamic>{};
      data["sortOption"][dirName] = <String, dynamic>{};
    }
    data["sortOption"][dirName][id.isEmpty ? "!HOME" : id] = sortOption;
  }

  void setViewOption({required String sortOption, required String id}) {
    var dirName = PathUtils.basename(appStorage.selectedUser.storagePath);
    if(data["sortOption"]?[dirName] is! Map) {
      data["sortOption"] = <String, dynamic>{};
      data["sortOption"][dirName] = <String, dynamic>{};
    }
    data["sortOption"][dirName][id.isEmpty ? "!HOME" : id] = sortOption;
  }

  bool shouldGroupNotes(String id) {
    var dirName = PathUtils.basename(appStorage.selectedUser.storagePath);
    if(data["shouldGroupNotes"]?[dirName] is Map) {
      var option = data["shouldGroupNotes"][dirName][id.isEmpty ? "!HOME" : id];
      if(option is bool) {
        return option;
      }
      else {
        return true;
      }
    }
    else {
      data["shouldGroupNotes"] = <String, dynamic>{};
      return true;
    }
  }

  void setShouldGroupNotes({required bool value, required String id}) {
    var dirName = PathUtils.basename(appStorage.selectedUser.storagePath);
    if(data["shouldGroupNotes"]?[dirName] is! Map) {
      data["shouldGroupNotes"] = <String, dynamic>{};
      data["shouldGroupNotes"][dirName] = <String, dynamic>{};
    }
    data["shouldGroupNotes"][dirName][id.isEmpty ? "!HOME" : id] = value;
  }

  String viewMode(String id) {
    var dirName = PathUtils.basename(appStorage.selectedUser.storagePath);
    if(data["viewMode"]?[dirName] is Map) {
      var option = data["viewMode"][dirName][id.isEmpty ? "!HOME" : id];
      if(option is String) {
        return option;
      }
      else {
        return "linear";
      }
    }
    else {
      data["viewMode"] = <String, dynamic>{};
      return "linear";
    }
  }

  void setViewMode({required String value, required String id}) {
    var dirName = PathUtils.basename(appStorage.selectedUser.storagePath);
    if(data["viewMode"]?[dirName] is! Map) {
      data["viewMode"] = <String, dynamic>{};
      data["viewMode"][dirName] = <String, dynamic>{};
    }
    data["viewMode"][dirName][id.isEmpty ? "!HOME" : id] = value;
  }
}