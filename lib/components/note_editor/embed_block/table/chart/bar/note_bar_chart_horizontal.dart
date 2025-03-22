import 'package:amphi/models/app.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/embed_block/table/table/note_table_block.dart';

class NoteBarChartHorizontal extends NoteTableBlock {
  const NoteBarChartHorizontal(
      {super.key,
      required super.readOnly,
      required super.tableData,
      required super.pageInfo, required super.removePage});

  @override
  State<NoteBarChartHorizontal> createState() => _NoteBarChartState();
}

class _NoteBarChartState extends State<NoteBarChartHorizontal> {
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barGroups = [];

    Map<String, dynamic> map = widget.tableData.toChartDataMap(widget.pageInfo);
    double width = map.length * 100;
    double bottomLabelSize = 50;

    if(map.length < 5) {
      width = map.length * 200;
    }

    for (int i = 0; i < map.keys.length; i++) {
      String title = map.keys.elementAt(i);
      if(title.length > 10) {
        bottomLabelSize = 90;
      }
      if(title.length > 15) {
        bottomLabelSize = 120;
      }
      if(title.length > 20) {
        bottomLabelSize = 150;
      }


      BarChartGroupData barChartGroupData = BarChartGroupData(x: i,
          barRods: [
        BarChartRodData(
          toY: map[title]!,
          color: Theme.of(context).highlightColor,
          width: 8,
          borderRadius: BorderRadius.zero,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
          ),
        ),
      ], showingTooltipIndicators: [
        0
      ]);

      barGroups.add(barChartGroupData);
    }



    FlTitlesData titlesData = FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              String text = map.keys.elementAt(value.toInt());
              return SideTitleWidget(
                  child: SizedBox(
                      width: 100,
                      height: bottomLabelSize,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          text,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          textAlign: TextAlign.center,
                        ),
                      )),
                meta: meta,
              );
            },
            reservedSize: bottomLabelSize,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 30),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)));

    var themeData = Theme.of(context);

    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: SizedBox(
            width: width,
            height: App.isWideScreen(context) ? 500 : 300,
            child: barGroups.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: BarChart(
                        BarChartData(
                        barTouchData: BarTouchData(
                          enabled: false,
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem(rod.toY.toStringAsFixed(0), TextStyle(
                                color: Theme.of(context).highlightColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                              )),
                                getTooltipColor: (group) =>
                                    Colors.transparent),

                        ),
                        borderData: FlBorderData(
                            border: Border(
                                left: BorderSide(color: themeData.dividerColor),
                                bottom:
                                    BorderSide(color: themeData.dividerColor))),
                        gridData: FlGridData(show: false),
                        barGroups: barGroups,
                        titlesData: titlesData)),
                  )
                : Icon(Icons.question_mark)),
      ),
    );
  }
}
