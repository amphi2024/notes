import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/models/theme_model.dart';

import '../database/database_helper.dart';

class ThemesState {
  final Map<String, ThemeModel> themes;
  final List<String> idList;

  const ThemesState(this.themes, this.idList);

  ThemeModel findThemeByIndex(int index) {
    return themes.get(idList[index]);
  }
}

class ThemesNotifier extends Notifier<ThemesState> {
  @override
  ThemesState build() {
    return ThemesState({}, []);
  }

  void insertTheme(ThemeModel themeModel) {
    final themes = {...state.themes, themeModel.id: themeModel};

    final mergedList = state.idList.contains(themeModel.id) ? [...state.idList] : [...state.idList, themeModel.id];

    state = ThemesState(themes, mergedList);
  }

  void deleteTheme(String id) {
    final themes = {...state.themes}..removeWhere((key, value) => key == id);
    final idList = state.idList.where((id1) => id1 != id).toList();

    state = ThemesState(themes, idList);
  }

  void init() async {
    Map<String, ThemeModel> themes = {};
    List<String> idList = [];
    final database = await databaseHelper.database;
    final List<Map<String, dynamic>> list = await database.rawQuery("SELECT * FROM themes", []);

    for(var data in list) {
      var theme = ThemeModel.fromMap(data);
      idList.add(theme.id);
      themes[theme.id] = theme;
    }

    state = ThemesState(themes, idList);
  }
}

final themesProvider = NotifierProvider<ThemesNotifier, ThemesState>(ThemesNotifier.new);

extension ThemesNullSafe on Map<String, ThemeModel> {
  ThemeModel get(String id) {
    return this[id] ?? ThemeModel(created: DateTime.now(), modified: DateTime.now());
  }
}