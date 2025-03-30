import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wellfi2/components/CustomAppBar.dart';
import 'package:wellfi2/constants.dart';
import 'package:wellfi2/utils/helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  List<DataItem<int>> stepCountData = [];
  List<DataItem<double>> distanceData = [];

  void getDataFromHealth() async {
    try {
      if (!await HealthConnectFactory.hasPermissions(types, readOnly: true)) {
        resultText = 'Please grant permissions first';
        _updateResultText();
        return;
      }

      final startTime = DateTime.now().subtract(const Duration(days: 8));
      final endTime = DateTime.now();

      final distanceRes = await HealthConnectFactory.getRecord(
        type: HealthConnectDataType.Distance,
        startTime: startTime,
        endTime: endTime,
      );
      final distanceByDay =
          Helper.extractDistanceByDay(jsonEncode(distanceRes));
      final tempDistanceData =
          Helper.convertStepsHashmapToKeyedMap<double>(distanceByDay);

      final stepRes = await HealthConnectFactory.getRecord(
        type: HealthConnectDataType.Steps,
        startTime: startTime,
        endTime: endTime,
      );

      final stepsByDay = Helper.extractStepsByDay(jsonEncode(stepRes));

      final DataItemData =
          Helper.convertStepsHashmapToKeyedMap<int>(stepsByDay);

      setState(
        () {
          stepCountData = DataItemData;
          distanceData = tempDistanceData;
          resultText = distanceRes.toString();
          data = distanceRes;
        },
      );
    } catch (e) {
      log(e.toString());
      resultText = 'Error fetching data: $e';
    }
    _updateResultText();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromHealth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar('Health Connect'),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: const BorderRadius.all(Radius.circular(14)),
            ),
            padding: const EdgeInsets.fromLTRB(5, 15, 10, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 5, top: 0),
                  child: Text(
                    'Steps taken',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      axisLine: AxisLine(color: Colors.grey.shade700),
                      labelStyle: TextStyle(color: Colors.grey.shade700),
                    ),
                    primaryYAxis: NumericAxis(
                      axisLine: AxisLine(color: Colors.grey.shade700),
                      labelStyle: TextStyle(color: Colors.grey.shade700),
                      numberFormat: NumberFormat.compact(),
                    ),
                    series: <CartesianSeries>[
                      ColumnSeries<DataItem, String>(
                        dataSource: stepCountData,
                        xValueMapper: (DataItem data, _) => data.date,
                        yValueMapper: (DataItem data, _) => data.steps,
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
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            // height: 200,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            padding: const EdgeInsets.fromLTRB(5, 15, 10, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 5, top: 0),
                  child: Text(
                    'Distance covered',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      axisLine: AxisLine(color: Colors.grey.shade700),
                      labelStyle: TextStyle(color: Colors.grey.shade700),
                    ),
                    primaryYAxis: NumericAxis(
                      axisLine: AxisLine(color: Colors.grey.shade700),
                      labelStyle: TextStyle(color: Colors.grey.shade700),
                      numberFormat: NumberFormat.compact(),
                    ),
                    series: <CartesianSeries>[
                      ColumnSeries<DataItem, String>(
                        dataSource: distanceData,
                        xValueMapper: (DataItem data, _) => data.date,
                        yValueMapper: (DataItem data, _) => data.steps,
                        color: kPrimaryColor,
                        enableTooltip: true,
                      ),
                    ],
                    trackballBehavior: TrackballBehavior(
                      enable: true,
                      activationMode: ActivationMode.singleTap,
                      tooltipSettings: InteractiveTooltip(
                        enable: true,
                        format: 'point.y m',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ElevatedButton(
          //   onPressed: getDataFromHealth,
          //   child: const Text('Get Health Data'),
          // ),
          // Container(
          //   height: 1000,
          //   child: FitnessRecordsWidget(
          //     data: data,
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: SelectableText(
          //     resultText,
          //     style: const TextStyle(fontFamily: 'monospace'),
          //   ),
          // ),
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
