import 'package:amphi/models/app_cache_data_core.dart';

final appCacheData = AppCacheData.getInstance();

class AppCacheData extends AppCacheDataCore {
  static final AppCacheData _instance = AppCacheData();
  static AppCacheData getInstance() => _instance;
}