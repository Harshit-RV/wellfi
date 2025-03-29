// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StepsChartScreenS extends StatelessWidget {
  StepsChartScreenS({Key? key}) : super(key: key);

  final List<StepData> stepCountData = [
    StepData('Mon', 3000),
    StepData('Tue', 6041),
    StepData('Wed', 5000),
    StepData('Thu', 4000),
    StepData('Fri', 4500),
    StepData('Sat', 5000),
    StepData('Sun', 0),
  ];

  final List<StepDistanceData> stepDistanceData = [
    StepDistanceData('Mon', 2.0),
    StepDistanceData('Tue', 3.83),
    StepDistanceData('Wed', 3.2),
    StepDistanceData('Thu', 2.5),
    StepDistanceData('Fri', 2.8),
    StepDistanceData('Sat', 3.0),
    StepDistanceData('Sun', 0.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Steps',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This Week',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    axisLine: AxisLine(color: Colors.grey),
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  primaryYAxis: NumericAxis(
                    axisLine: AxisLine(color: Colors.grey),
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  // palette: [Color(values: 0xFFE77728)],
                  plotAreaBorderWidth: 0,
                  // title: ChartTitle(text: 'COUNT'),
                  series: <CartesianSeries>[
                    ColumnSeries<StepData, String>(
                      dataSource: stepCountData,
                      xValueMapper: (StepData data, _) => data.day,
                      yValueMapper: (StepData data, _) => data.steps,
                      color: Color(0xFFE77728),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                 padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    axisLine: AxisLine(color: Colors.grey.shade700),
                    labelStyle: TextStyle(color: Colors.grey.shade700),
                  ),
                  primaryYAxis: NumericAxis(
                    axisLine: AxisLine(color: Colors.grey.shade700),
                    labelStyle: TextStyle(color: Colors.grey.shade700),
                  ),
                  // title: ChartTitle(text: 'DISTANCE'),
                  series: <CartesianSeries>[
                    ColumnSeries<StepDistanceData, String>(
                      dataSource: stepDistanceData,
                      xValueMapper: (StepDistanceData data, _) => data.day,
                      yValueMapper: (StepDistanceData data, _) => data.distance,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StepData {
  final String day;
  final int steps;

  StepData(this.day, this.steps);
}

class StepDistanceData {
  final String day;
  final double distance;

  StepDistanceData(this.day, this.distance);
}
