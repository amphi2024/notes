class TableData {

  final List< List<  Map<String, dynamic> > > data;
  final List<Map<String, dynamic>> views;

  TableData({List< List<  Map<String, dynamic> > > ? data, List<Map<String, dynamic>>? views }) : data = data ?? [ [ {}, {} ] , [{}, {}] ], views = views ?? [ {"type": "table"} ];

  String viewMode = "linear";

  static TableData fromMap(Map<String, dynamic> map) {
    try {
      List<List<Map<String, dynamic>>> data = (map["value"] as List)
          .map((innerList) => (innerList as List)
          .map((item) => item as Map<String, dynamic>)
          .toList())
          .toList();

      final views = map["style"]["views"] ?? map["style"]["pages"];

      return TableData(
        data: data,
        views: views.cast<Map<String, dynamic>>() ?? [ {"type": "table"} ]
      );
    }
    catch(e) {
      return TableData(
        data: [ [ {
          "text": map["value"].toString()
        } , {}] , [{} , {}]  ]
      );
    }
  }

  TableData copy() {
    final copiedData = data
        .map((row) =>
        row.map((cell) => Map<String, dynamic>.from(cell)).toList())
        .toList();

    final copiedViews =
    views.map((view) => Map<String, dynamic>.from(view)).toList();

    return TableData(data: copiedData, views: copiedViews);
  }
}

Map<String, dynamic> chartViewData(TableData tableData, int viewIndex) {
  Map<String, double> map = {};

  //tableData.views[viewIndex] = viewInfo
  for(List<Map<String, dynamic>> list in tableData.data) {
    String title = list[tableData.views[viewIndex]["rowIndex"] ?? 0]["text"] ?? "";
    if(title.isNotEmpty) {
      if(map[title] == null) {
        map[title] = 1;
      }
      else {
        map[title] = map[title]! + 1;
      }
    }
  }

  var sortedEntries = map.entries.toList()
    ..sort((a, b) => a.value.compareTo(b.value)); // Ascending order


  if(tableData.views[viewIndex]["ascending"] == false) {
    sortedEntries = sortedEntries.reversed.toList();
  }
  // Convert sorted entries back to a map
  Map<String, double> sortedMap = Map.fromEntries(sortedEntries);

  return sortedMap;
}

