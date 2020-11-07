/// CTSE Final Flutter Project - Suzuki Automobile
///
/// CarPopularity.dart file contains the code to display the car model popularity
/// chart.
/// When creating the chart, I have used the chart_flutter documentation.
/// References: Dart packages. 2020. Charts_Flutter | Flutter Package. [online]
/// Available at: <https://pub.dev/packages/charts_flutter> [Accessed 18 April 2020].
///
/// @Author : IT17009096 | Wellala S.S.

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:suzukiautomobile/models/PopularityModel.dart';
import 'package:suzukiautomobile/widgets/BaseAppBar.dart';

class CarPopularity extends StatefulWidget {
  @override
  _CarPopularityState createState() => _CarPopularityState();
}

class _CarPopularityState extends State<CarPopularity> {
  List<charts.Series<PopularityModel, String>> _seriesPieData;

  /// Chart details are created. These are dummy values used to show case
  /// the use case scenario. These data are from the [PopularityModel] class. In
  _generateData() {
    // Giving the model name, percentage of the popularity and the color
    var pieData = [
      new PopularityModel("Swift", 28.8, Color(0xFF3366cc)),
      new PopularityModel("Alto", 48.5, Color(0xFF990099)),
      new PopularityModel("Jimny", 8.6, Color(0xFF109618)),
      new PopularityModel("S-Presso", 2.3, Color(0xFFdc3912))
    ];
    // Adding data to the chart as a series of data.
    _seriesPieData.add(charts.Series(
      data: pieData,
      domainFn: (PopularityModel popularity, _) => popularity.model,
      measureFn: (PopularityModel popularity, _) => popularity.value,
      colorFn: (PopularityModel popularity, _) =>
          charts.ColorUtil.fromDartColor(popularity.colorVal),
      id: 'Model Popularity',
      labelAccessorFn: (PopularityModel row, _) => '${row.value}',
    ));
  }

  @override
  void initState() {
    super.initState();
    // Creating the List series to feed into the chart
    _seriesPieData = List<charts.Series<PopularityModel, String>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BaseAppBar(
        title: Text('Popularity of the Models'),
        appBar: AppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  // Drawing the chart
                  child: charts.PieChart(
                    _seriesPieData,
                    animate: true,
                    animationDuration: Duration(seconds: 3),
                    behaviors: [
                      new charts.DatumLegend(
                          outsideJustification:
                              charts.OutsideJustification.endDrawArea,
                          horizontalFirst: false,
                          desiredMaxRows: 2,
                          cellPadding:
                              new EdgeInsets.only(right: 4.0, bottom: 4.0),
                          entryTextStyle: charts.TextStyleSpec(
                              color: charts.MaterialPalette.purple.shadeDefault,
                              fontFamily: 'Georgia',
                              fontSize: 12))
                    ],
                    // This is to create the labels which can be used to identify the values in the chart
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 100,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                              labelPosition: charts.ArcLabelPosition.inside)
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
