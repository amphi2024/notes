import 'package:amphi/models/app.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:notes/components/note_editor/embed_block/table/table/note_table_block.dart';

class NoteBarChartHorizontal extends NoteTableBlock {

  const NoteBarChartHorizontal({super.key, required super.readOnly, required super.tableData, required super.pageInfo});

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
    double width = map.keys.length * 100;

    for(int i = 0 ; i < map.keys.length; i++) {
      String title = map.keys.elementAt(i);
      BarChartGroupData barChartGroupData = BarChartGroupData(x: i, barRods: [
        BarChartRodData(toY: map[title]!, color: Theme.of(context).highlightColor),
      ], showingTooltipIndicators: [0]);

      barGroups.add(barChartGroupData);
    }

    FlTitlesData titlesData = FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) {
            String text = map.keys.elementAt(value.toInt());
            return SideTitleWidget(child: Text(text), axisSide: meta.axisSide);
          },
          reservedSize: 30,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: true, reservedSize: 30),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false
        )
      )
    );


      return Scrollbar(
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
              width: width,
              height: App.isWideScreen(context) ? 500 : 300,
              child: barGroups.isNotEmpty ? Padding(
                padding: const EdgeInsets.only(top: 80),
                child: BarChart(
                    BarChartData(
                        barGroups: barGroups,
                        titlesData: titlesData
                    )),
              ) : Icon(Icons.question_mark)),
        ),
      );

  }
}