import 'package:amphi/models/app_cache_data_core.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:notes/models/sort_option.dart';

import 'app_storage.dart';

final appCacheData = AppCacheData.getInstance();

class AppCacheData extends AppCacheDataCore {
  static final AppCacheData _instance = AppCacheData();
  static AppCacheData getInstance() => _instance;

  String sortOption(String id) {
    var dirName = PathUtils.basename(appStorage.selectedUser.storagePath);
    if(data["sortOption"]?[dirName] is Map) {
      var option = data["sortOption"][dirName][id];
      if(option is String) {
        return option;
      }
      else {
        return SortOption.created;
      }
    }
    else {
      data["sortOption"] = <String, dynamic>{};
      return SortOption.created;
    }
  }

  void setSortOption({required String sortOption, required String id}) {
    var dirName = PathUtils.basename(appStorage.selectedUser.storagePath);
    if(data["sortOption"]?[dirName] is! Map) {
      data["sortOption"] = <String, dynamic>{};
      data["sortOption"][dirName] = <String, dynamic>{};
    }
    data["sortOption"][dirName][id] = sortOption;
  }
}