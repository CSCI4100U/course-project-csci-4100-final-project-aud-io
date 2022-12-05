import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:group_project/MainScreen_Model/nav.dart';
import '../models/countries.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

class StatisticsChart extends StatefulWidget {
  StatisticsChart({Key? key, this.title, required this.frequencies}) : super(key: key);
  final String? title;
  List<CountryFrequency> frequencies = [];
  @override
  State<StatisticsChart> createState() => _StatisticsChartState();
}

class _StatisticsChartState extends State<StatisticsChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarForSubPages(
          context,
        (FlutterI18n.translate(context, "titles.stats_chart")),
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: SizedBox(
              height: 500,
              child: charts.BarChart(
                  [
                    charts.Series(
                        colorFn: (_,__) => charts.MaterialPalette.blue.shadeDefault,
                        id: "Country User Frequency",
                        domainFn: (gf,_) => gf.country,
                        measureFn: (gf,_) => gf.frequency,
                        data: widget.frequencies!
                    ),
                  ],
                  animate: true,
                  vertical: false
              )
          )
      ),
    );
  }
}
