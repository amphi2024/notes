import 'package:amphi/models/app_storage_core.dart';
import 'package:amphi/utils/path_utils.dart';

final appStorage = AppStorage.getInstance();

class AppStorage extends AppStorageCore {
  static final AppStorage _instance = AppStorage._internal();
  AppStorage._internal();

  late String attachmentsPath;
  late String themesPath;
  static AppStorage getInstance() => _instance;

  String get databasePath => PathUtils.join(selectedUser.storagePath, "notes.db");

  @override
  void initPaths() {
    super.initPaths();
    attachmentsPath = PathUtils.join(selectedUser.storagePath, "attachments");
    themesPath = PathUtils.join(selectedUser.storagePath, "themes");

  }

}