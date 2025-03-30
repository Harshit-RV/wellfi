import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wellfi2/components/CustomAppBar.dart';

class FitnessData extends StatefulWidget {
  const FitnessData({super.key});

  @override
  State<FitnessData> createState() => _FitnessDataState();
}

class _FitnessDataState extends State<FitnessData> {
  List<HealthConnectDataType> types = [
    HealthConnectDataType.Power,
    HealthConnectDataType.Distance,
    HealthConnectDataType.Steps,
    HealthConnectDataType.TotalCaloriesBurned,
    HealthConnectDataType.HeartRate,
    HealthConnectDataType.SleepSession,
    HealthConnectDataType.OxygenSaturation,
    HealthConnectDataType.RespiratoryRate,
  ];

  bool readOnly = false;
  Map<String, dynamic> data = {};
  String resultText = '';

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
      appBar: buildCustomAppBar('Health Connect'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 200,
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
          ElevatedButton(
            onPressed: () async {
              var result = await HealthConnectFactory.isApiSupported();
              resultText = 'isApiSupported: $result';
              _updateResultText();
            },
            child: const Text('Check API Support'),
          ),
          ElevatedButton(
            onPressed: () async {
              var result = await HealthConnectFactory.isAvailable();
              resultText = 'isAvailable: $result';
              _updateResultText();
            },
            child: const Text('Check Installed'),
          ),
          ElevatedButton(
            onPressed: () async {
              await HealthConnectFactory.installHealthConnect();
            },
            child: const Text('Install Health Connect'),
          ),
          ElevatedButton(
            onPressed: () async {
              await HealthConnectFactory.openHealthConnectSettings();
            },
            child: const Text('Open Settings'),
          ),
          ElevatedButton(
            onPressed: () async {
              var result = await HealthConnectFactory.hasPermissions(
                types,
                readOnly: readOnly,
              );
              resultText = 'hasPermissions: $result';
              _updateResultText();
            },
            child: const Text('Check Permissions'),
          ),
          ElevatedButton(
            onPressed: () async {
              var result = await HealthConnectFactory.requestPermissions(
                types,
                readOnly: readOnly,
              );
              resultText = 'requestPermissions: $result';
              _updateResultText();
            },
            child: const Text('Request Permissions'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                if (!await HealthConnectFactory.hasPermissions(types,
                    readOnly: true)) {
                  resultText = 'Please grant permissions first';
                  _updateResultText();
                  return;
                }

                final startTime =
                    DateTime.now().subtract(const Duration(days: 3));
                final endTime = DateTime.now();

                // no data: blood pressure, active calories burned, ElevationGained, ExerciseSession, FloorsClimbed, HeartRate
                // yes data: distance, calories, steps, Height, Weight
                final results = await HealthConnectFactory.getRecord(
                  type: HealthConnectDataType.Steps,
                  startTime: startTime,
                  endTime: endTime,
                );

                // log(results.toString());

                // final buffer = StringBuffer();
                // results.forEach((dataType, records) {
                //   for (final record in records) {
                //     buffer.writeln('${record}: ${record} steps');
                //   }
                //   buffer.writeln('\n');
                // });

                setState(() {
                  // resultText = buffer.toString();

                  resultText = results.toString();
                  data = results;
                });
              } catch (e) {
                log(e.toString());
                resultText = 'Error fetching data: $e';
              }
              _updateResultText();
            },
            child: const Text('Get Health Data'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SelectableText(
              resultText,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  void _updateResultText() {
    setState(() {});
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
