/*
* Author: Alessandro Prataviera
* */

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:group_project/statistics_classes/views/statistics_chart.dart';
import 'package:group_project/user_classes/models/user_model.dart';
import '../../MainScreen_Model/app_constants.dart';
import 'package:group_project/statistics_classes/models/countries.dart';

class StatisticsDataTable extends StatefulWidget {
  const StatisticsDataTable({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  State<StatisticsDataTable> createState() => _StatisticsDataTableState();
}

class _StatisticsDataTableState extends State<StatisticsDataTable> {
  var allUsers = [];
  List<CountryFrequency> frequencies = [];
  final UserModel _model = UserModel();
  int? _sortColumnIndex;
  bool? _sortAscending;

  @override
  void initState() {
    super.initState();
    getAllUsers();
    _sortColumnIndex=0;
    _sortAscending=true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            FlutterI18n.translate(context, "titles.stats_table"),
              style: style,
          ),
        actions: [
          SizedBox(
            width: 37,
            child: IconButton(
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StatisticsChart(
                          frequencies: frequencies
                      ))
                  );
                },
                tooltip: 'chart',
                icon: const Icon(Icons.bar_chart)
            ),
          ),
          SizedBox(
            width: 37,
            child: IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/home');
                },
                tooltip: 'Home',
                icon: const Icon(Icons.home)
            ),
          )
        ],
      ),
      body: DataTable(
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending!,
        columns: [
          DataColumn(
            label: Text(FlutterI18n.translate(context, "forms.country")),
            tooltip: "Country",
              onSort: (index, ascending) {
                setState(() {
                  _sortColumnIndex = index;
                  _sortAscending = ascending;
                  frequencies!.sort(
                          (a,b) {
                        if (ascending){
                          return a.country!.compareTo(b.country!);
                        }
                        return b.country!.compareTo(a.country!);
                      }
                  );
                });
              }
          ),
          DataColumn(
            label: Text(FlutterI18n.translate(context, "charts.freq")),
            tooltip: "Frequency",
            onSort: (index, ascending) {
              setState(() {
                _sortColumnIndex = index;
                _sortAscending = ascending;
                frequencies!.sort(
                        (a,b) {
                      if (ascending){
                        return a.frequency!.compareTo(b.frequency!);
                      }
                      return b.frequency!.compareTo(a.frequency!);
                    }
                );
              });
            }
          ),
        ],
        rows: frequencies!.map((CountryFrequency country) => DataRow(
            cells: [
              DataCell(Text(country.country!.toString())),
              DataCell(
                  Text(country.frequency!.toString()),
              ),
            ]
        )
        ).toList(),
      ),
    );
  }
  getAllUsers() async{
    allUsers = await _model.getAllUsers();
    setState(() {
      frequencies = _calculateCountryFrequencies();
    });
    print(allUsers);
  }

  List<CountryFrequency> _calculateCountryFrequencies(){

    Map<String, int > frequencies = {};
    for (Country country in countries) {
      frequencies[country.name!] = 0;
    }
    //print(frequencies);

    int? frequency;

    for (int i = 0; i < countries.length; i++){
      for(int j = 0; j < allUsers.length; j++){
        if (allUsers[j].country == countries[i].name){
          frequency = frequencies[allUsers[j].country];
          frequencies[allUsers[j].country] = frequency!+1;
        }
        else {
          print("user has a invalid country registered");
        }
      }
    }

    var list = countries.map(
            (country) => CountryFrequency(
            country: country.name,
            frequency: frequencies[country.name]
        ))
        .toList();

    List<CountryFrequency> usersFrequencies = [];

    for (CountryFrequency country in list) {
      if (country.frequency! > 0) {
        usersFrequencies.add(country);
      }
    }
    print(usersFrequencies);
    return usersFrequencies;
  }

}



