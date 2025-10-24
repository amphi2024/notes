import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedNotesNotifier extends Notifier<List<String>?> {

  bool keyPressed = false;

  @override
  List<String>? build() {
    return null;
  }

  void startSelection() {
    state = [];
  }

  void endSelection() {
    state = null;
  }

  void addId(String id) {
    if(state == null) {
      return;
    }
    if (!state!.contains(id)) {
      state = [...state!, id];
    }
  }

  void removeId(String id) {
    if(state == null) {
      return;
    }
    state = state!.where((e) => e != id).toList();
  }

  void notifyEditingNote(String id) {
    state = [id];
  }
}

final selectedNotesProvider = NotifierProvider<SelectedNotesNotifier, List<String>?>(SelectedNotesNotifier.new);