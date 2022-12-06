/*
* Author: Alessandro Prataviera
* */

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:group_project/MainScreen_Model/navigation_bar.dart';
import '../../MainScreen_Model/app_constants.dart';
import '../models/countries.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

class StatisticsChart extends StatefulWidget {
  const StatisticsChart({Key? key, this.title, required this.frequencies}) : super(key: key);
  final String? title;
  final List<CountryFrequency> frequencies;
  @override
  State<StatisticsChart> createState() => _StatisticsChartState();
}

class _StatisticsChartState extends State<StatisticsChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((FlutterI18n.translate(context, "titles.stats_chart"))),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/home');
            },
            icon: Icon(Icons.home),
          ),
        ]
      ),
      body: Container(
          padding: padding,
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
