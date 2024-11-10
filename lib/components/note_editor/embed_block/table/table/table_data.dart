class TableData {

  List< List<  Map<String, dynamic> > > data = [ [ {}, {} ] , [{}, {}] ];
  List<Map<String, dynamic>> pages = [ {"type": "table"} ];

  String viewMode = "linear";

  Map<String, dynamic> toChartDataMap(Map<String, dynamic> pageInfo) {
    Map<String, double> map = {};
    for(List<Map<String, dynamic>> list in data) {
      String title = list[pageInfo["row-index"] ?? 0]["text"] ?? "";
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

    if(pageInfo["ascending"] == false) {
      sortedEntries = sortedEntries.reversed.toList();
    }
    // Convert sorted entries back to a map
    Map<String, double> sortedMap = Map.fromEntries(sortedEntries);

    return sortedMap;
  }
}

