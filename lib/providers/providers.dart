import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/models/note.dart';

class FloatingButtonNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setRotated(bool value) {
    state = value;
  }
}

final floatingButtonStateProvider = NotifierProvider<FloatingButtonNotifier, bool>(FloatingButtonNotifier.new);

final searchKeywordProvider = NotifierProvider<SearchKeywordNotifier, String?>(SearchKeywordNotifier.new);

class SearchKeywordNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  void setKeyword(String keyword) {
    state = keyword;
  }

  void startSearch() {
    state = "";
  }

  void endSearch() {
    state = null;
  }
}

class ViewModeNotifier extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() {
    return {};
  }

  void setViewMode(String id, String value) {
    state = {...state, id: value};
  }
}

final viewModeProvider = NotifierProvider<ViewModeNotifier, Map<String, String>>(ViewModeNotifier.new);

class WideMainPageState {
  final bool sideBarShowing;
  final bool sideBarFloating;
  final double sideBarWidth;
  final double notesViewWidth;

  const WideMainPageState({required this.sideBarFloating, required this.notesViewWidth, required this.sideBarShowing, required this.sideBarWidth});

  WideMainPageState copyWith({
    bool? sideBarShowing,
    bool? sideBarFloating,
    double? sideBarWidth,
    double? notesViewWidth
}) {
    return WideMainPageState(sideBarFloating: sideBarFloating ?? this.sideBarFloating,
        notesViewWidth: notesViewWidth ?? this.notesViewWidth,
        sideBarShowing: sideBarShowing ?? this.sideBarShowing,
        sideBarWidth: sideBarWidth ?? this.sideBarWidth);
  }
}

class WideMainPageStateNotifier extends Notifier<WideMainPageState> {
  @override
  WideMainPageState build() {
    return WideMainPageState(sideBarFloating: false, notesViewWidth: 250, sideBarShowing: true, sideBarWidth: 200);
  }

  void setSideBarShowing(bool value) {
    state = state.copyWith(sideBarShowing: value);
  }

  void setSideBarFloating(bool value) {
    state = state.copyWith(sideBarFloating: value);
  }
  void setSideBarWidth(double width) {
    if(width > 150) {
      state = state.copyWith(sideBarWidth: width);
    }
  }
  void setNotesViewWidth(double value) {
    if(value > 200) {
      state = state.copyWith(notesViewWidth: value);
    }
  }
}

final wideMainPageStateProvider = NotifierProvider<WideMainPageStateNotifier, WideMainPageState>(WideMainPageStateNotifier.new);

class SelectedFolderProvider extends Notifier<String> {
  @override
  String build() {
    return "";
  }

  void setFolderId(String id) {
    state = id;
  }
}

final selectedFolderProvider = NotifierProvider<SelectedFolderProvider, String>(SelectedFolderProvider.new);