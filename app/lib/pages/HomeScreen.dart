import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:wellfi2/comp.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wellfi2/constants.dart';
import 'package:wellfi2/utils/list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<HealthConnectDataType> types = [
    HealthConnectDataType.Power,
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

  List<StepDataItem> stepCountData = [];

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
        title: const Text('Health Connect'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(0),
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
              series: <CartesianSeries>[
                ColumnSeries<StepDataItem, String>(
                  dataSource: stepCountData,
                  xValueMapper: (StepDataItem data, _) => data.date,
                  yValueMapper: (StepDataItem data, _) => data.steps,
                  color: kPrimaryColor,
                  enableTooltip: true,
                ),
              ],
              trackballBehavior: TrackballBehavior(
                enable: true,
                activationMode: ActivationMode.singleTap,
                tooltipSettings: InteractiveTooltip(
                  enable: true,
                  format: 'point.y Steps',
                ),
              ),
            ),
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
                    DateTime.now().subtract(const Duration(days: 100));
                final endTime = DateTime.now();

                final results = await HealthConnectFactory.getRecord(
                  type: HealthConnectDataType.Steps,
                  startTime: startTime,
                  endTime: endTime,
                  // aggregation: AggregationType.daily,
                );

                // log(results.toString());
                final stepsByDay =
                    Helper.extractStepsByDay(jsonEncode(results));

                final stepDataItemData =
                    Helper.convertStepsHashmapToKeyedMap(stepsByDay);

                log(stepsByDay.toString());
                print(stepDataItemData);

                setState(
                  () {
                    stepCountData = stepDataItemData;
                    resultText = results.toString();
                    data = results;
                  },
                );
              } catch (e) {
                log(e.toString());
                resultText = 'Error fetching data: $e';
              }
              _updateResultText();
            },
            child: const Text('Get Health Data'),
          ),
          Container(
            height: 1000,
            child: FitnessRecordsWidget(
              data: data,
            ),
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
