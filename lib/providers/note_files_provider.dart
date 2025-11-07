import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/models/file_model.dart';

class NoteFilesNotifier extends Notifier<Map<String, FileModel>> {
  @override
  Map<String, FileModel> build() {
    return {};
  }

  void setFiles(Map<String, FileModel> files) {
    state = files;
  }

  void insertFile(FileModel model) {
    state = {...state, model.filename: model};
  }
}

final noteFilesProvider = NotifierProvider<NoteFilesNotifier, Map<String, FileModel>>(NoteFilesNotifier.new);