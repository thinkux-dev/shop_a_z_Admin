import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_a_z/providers/order_provider.dart';
import 'package:shop_a_z/providers/telescope_provider.dart';

class ReportPage extends StatefulWidget {
  static const String routeName = 'report';

  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Text('Brand sale report'),
              SizedBox(
                width: 300,
                height: 300,
                child: Consumer<OrderProvider>(
                  builder: (context, provider, child) =>
                      FutureBuilder<List<Map<String, dynamic>>>(
                    future: provider.preparePieChartDataForBrand(
                        Provider.of<TelescopeProvider>(context, listen: false)
                            .telescopeList),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final mapList = snapshot.data!;
                        return PieChart(PieChartData(
                            sections: mapList
                                .map((map) => PieChartSectionData(
                                    title:
                                        '${map['brand']}\n${(map['percent'] as double).round()}%',
                                    showTitle: true,
                                    value: map['percent'],
                                    color: map['color'],
                                    radius: 80,
                                    titleStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white)))
                                .toList()));
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Error loading data'),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text('Yearly sale report'),
              SizedBox(
                width: 200,
                height: 200,
                child: YearPicker(
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  selectedDate: selectedDate,
                  onChanged: (value) {
                    setState(() {
                      selectedDate = value;
                    });
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 400,
                child: Consumer<OrderProvider>(
                  builder: (context, provider, child) =>
                      FutureBuilder<Map<num, double>>(
                    future: provider.prepareLineChartForYearlySale(selectedDate.year),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final map = snapshot.data!;
                        return LineChart(LineChartData(
                            minX: 1,
                            minY: 0,
                            maxX: 12,
                            maxY: provider.findMaxY(map),
                            lineBarsData: [
                              LineChartBarData(
                                spots: provider.generateSpots(map),
                                isCurved: true,
                                isStrokeCapRound: true,
                                barWidth: 4,
                                color: Colors.deepPurple,
                              ),
                            ],
                            titlesData: const FlTitlesData(
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                  axisNameWidget: Text('Month of the year'),
                                  sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 30,
                                      getTitlesWidget: getBottomTitleWidgets)),
                            )));
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Error loading data'),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  PieChart buildPieChart() {
    return PieChart(
      PieChartData(
        sections: generateSections(),
      ),
    );
  }

  List<PieChartSectionData> generateSections() {
    final shadows = [Shadow(color: Colors.black, blurRadius: 2)];
    return List.generate(
        4,
        (index) => PieChartSectionData(
            title: 'Title ${index + 1}',
            value: 25.0,
            showTitle: true,
            radius: 70,
            color: Color.fromARGB(255, 150, 20 * index, 30 * index),
            titleStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              shadows: shadows,
            )));
  }

  LineChart buildLineChart() {
    return LineChart(LineChartData(
      minX: 0,
      minY: 0,
      maxX: 11,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 0.5),
            FlSpot(1, 3),
            FlSpot(2, 6),
            FlSpot(3, 4),
            FlSpot(4, 3),
            FlSpot(5, 2),
            FlSpot(7, 6),
            FlSpot(9, 5),
          ],
          isCurved: true,
          isStrokeCapRound: true,
          barWidth: 4,
          color: Colors.amber,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
          ),
        )
      ],
    ));
  }
}

Widget getBottomTitleWidgets(double value, TitleMeta meta) {
  Widget text;
  const style = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  switch (value.toInt()) {
    case 2:
      text = const Text(
        'FEB',
        style: style,
      );
      break;
    case 4:
      text = const Text(
        'APR',
        style: style,
      );
      break;
    case 6:
      text = const Text(
        'JUN',
        style: style,
      );
      break;
    case 8:
      text = const Text(
        'AUG',
        style: style,
      );
      break;
    case 10:
      text = const Text(
        'OCT',
        style: style,
      );
      break;
    case 12:
      text = const Text(
        'DEC',
        style: style,
      );
      break;
    default:
      text = const Text(
        '',
        style: style,
      );
      break;
  }
  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}
