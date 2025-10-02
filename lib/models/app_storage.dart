import 'package:amphi/models/app_storage_core.dart';
import 'package:amphi/utils/path_utils.dart';

final appStorage = AppStorage.getInstance();

class AppStorage extends AppStorageCore {
  static final AppStorage _instance = AppStorage._internal();
  AppStorage._internal();

  late String notesPath;
  late String themesPath;
  static AppStorage getInstance() => _instance;

  List<dynamic> selectedNotes = [];

  @override
  void initPaths() {
    super.initPaths();
    notesPath = PathUtils.join(selectedUser.storagePath, "notes");
    themesPath = PathUtils.join(selectedUser.storagePath, "themes");

    createDirectoryIfNotExists(notesPath);
    createDirectoryIfNotExists(themesPath);
  }

}