import 'package:flutter_riverpod/flutter_riverpod.dart';

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