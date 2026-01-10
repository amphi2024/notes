import 'package:amphi/utils/random_string.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/models/table_data.dart';

class TableState {
  final List<TableData> history;
  final int index;

  const TableState(this.history, this.index);
  
  TableData data() => history[index];
}

class TablesNotifier extends Notifier<Map<String, TableState>> {
  @override
  Map<String, TableState> build() {
    return {};
  }

  static Map<String, TableState> initialized(Map<String, TableData> tables) {
    final Map<String, TableState> map = {};
    tables.forEach((key, value) {
      map[key] = TableState([value], 0);
    });
    return map;
  }

  void setTables(Map<String, TableData> tables) {
    state = initialized(tables);
  }

  void clear() {
    state = {};
  }

  String generatedId() {
    String id = randomString(9, 3);
    if (state.containsKey(id)) {
      return generatedId();
    } else {
      return id;
    }
  }

  void insertTable(String id, TableData tableData) {
    state = {
      ...state,
      id: TableState([tableData], 0)
    };
  }

  void addColumn(String id, int index) => _commitChange(id, (tableData) {
    for (int j = 0; j < tableData.data.length; j++) {
      tableData.data[j].insert(index, {"text": ""});
    }
    return tableData;
  });

  void addRow(String id, int index) => _commitChange(id, (tableData) {
    final newRow = List.generate(
      tableData.data.first.length,
          (_) => {"text": ""},
    );
    tableData.data.insert(index, newRow);
    return tableData;
  });

  void removeRow(String id, int index) => _commitChange(id, (tableData) {
    tableData.data.removeAt(index);
    return tableData;
  });

  void removeColumn(String id, int index) => _commitChange(id, (tableData) {
    for (int j = 0; j < tableData.data.length; j++) {
      tableData.data[j].removeAt(index);
    }
    return tableData;
  });

  void setValue({
    required String id,
    required int rowIndex,
    required int colIndex,
    required Map<String, dynamic> value,
  }) =>
      _commitChange(id, (tableData) {
        tableData.data[rowIndex][colIndex] = value;
        return tableData;
      });

  void _commitChange(String id, TableData Function(TableData data) modify) {
    final tableState = state[id];
    if (tableState == null) return;

    final truncatedHistory = tableState.history.sublist(0, tableState.index + 1);

    final newData = modify(tableState.data().copy());

    final newHistory = [...truncatedHistory, newData];
    final newIndex = newHistory.length - 1;

    state = {
      ...state,
      id: TableState(newHistory, newIndex),
    };
  }

  void undo(String id) {
    final tableState = state[id]!;
    final index = tableState.index - 1;
    if(index < 0) {
      return;
    }
    state = {
      ...state,
      id: TableState(tableState.history, index)
    };
  }

  void redo(String id) {
    final tableState = state[id]!;
    final index = tableState.index + 1;
    if(index > tableState.history.length - 1) {
      return;
    }
    state = {
      ...state,
      id: TableState(tableState.history, index)
    };
  }

  void insertView(String id, int index, Map<String, dynamic> view) => _commitChange(id, (tableData) {
    tableData.views.insert(index, view);
    return tableData;
  });

  void updateView(String id, int index, String key, dynamic value) => _commitChange(id, (tableData) {
    tableData.views[index][key] = value;
    return tableData;
  });

  void removeView(String id, int index) => _commitChange(id, (tableData) {
    tableData.views.removeAt(index);
    return tableData;
  });
}

final tablesProvider = NotifierProvider<TablesNotifier, Map<String, TableState>>(TablesNotifier.new);
