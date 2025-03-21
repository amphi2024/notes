import 'package:notes/models/content.dart';

class TableData {

  List< List<  Map<String, dynamic> > > data = [ [ {}, {} ] , [{}, {}] ];
  List<Map<String, dynamic>> pages = [ {"type": "table"} ];

  String viewMode = "linear";

  Map<String, dynamic> toChartDataMap(Map<String, dynamic> pageInfo) {
    Map<String, double> map = {};
    for(List<Map<String, dynamic>> list in data) {
      String title = list[pageInfo["rowIndex"] ?? 0]["text"] ?? "";
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

  static TableData fromContent(Content content) {
    TableData tableData = TableData();
    try {
      List<List<Map<String, dynamic>>> data = (content.value as List)
          .map((innerList) => (innerList as List)
          .map((item) => item as Map<String, dynamic>)
          .toList())
          .toList();

      tableData.data = data;
      if(content.style?["pages"] is List<dynamic>) {
        tableData.pages = content.style?["pages"].cast<Map<String, dynamic>>() ?? [ {"type": "table"} ];
      }
    }
    catch(e) {
      tableData.pages.add({
        "type": "table"
      });
    }


    return tableData;
  }
}

