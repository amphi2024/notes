import 'package:amphi/utils/path_utils.dart';

import '../models/app_storage.dart';

String noteAttachmentDirPath(String id, String type) {
  return PathUtils.join(appStorage.attachmentsPath, id[0], id[1] , id, type);
}

String noteImagePath(String id, String filename) {
  return PathUtils.join(appStorage.attachmentsPath, id[0], id[1] , id, "images", filename);
}

String noteVideoPath(String id, String filename) {
  return PathUtils.join(appStorage.attachmentsPath, id[0], id[1] , id, "videos", filename);
}