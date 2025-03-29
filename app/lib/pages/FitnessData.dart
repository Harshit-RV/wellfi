import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:permission_handler/permission_handler.dart';

class FitnessData extends StatefulWidget {
  const FitnessData({super.key});

  @override
  State<FitnessData> createState() => _FitnessDataState();
}

class _FitnessDataState extends State<FitnessData> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Connect'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
          // Container(
          //   height: 1000,
          //   child: FitnessRecordsWidget(
          //     data: data,
          //   ),
          // ),
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
