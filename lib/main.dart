import 'package:flutter/material.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'dart:developer';

import 'package:wellfi2/comp.dart';
import 'package:wellfi2/pages/HomeScreen.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<HealthConnectDataType> types = [
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Health Connect'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: const Text('go to home'),
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

                  final results = await HealthConnectFactory.getRecord(
                    type: HealthConnectDataType.TotalCaloriesBurned,
                    startTime: startTime,
                    endTime: endTime,
                  );

                  log(results.toString());
                  setState(() {
                    resultText = results.toString();
                    data = results;
                  });
                  // final buffer = StringBuffer();
                  // results.forEach((dataType, records) {
                  //   buffer.writeln('=== ${dataType.name.toUpperCase()} ===');

                  //   for (final record in records) {
                  //     switch (dataType) {
                  //       case HealthConnectDataType.Steps:
                  //         buffer.writeln(
                  //           '${record.startTime}: ${(record as StepsRecord).count} steps'
                  //         );
                  //         break;
                  //       case HealthConnectDataType.HeartRate:
                  //         buffer.writeln(
                  //           '${record.time}: ${(record as HeartRateRecord).beatsPerMinute} BPM'
                  //         );
                  //         break;
                  //       case HealthConnectDataType.SleepSession:
                  //         final sleep = record as SleepSessionRecord;
                  //         buffer.writeln(
                  //           'Sleep from ${sleep.startTime} to ${sleep.endTime}'
                  //         );
                  //         break;
                  //       case HealthConnectDataType.OxygenSaturation:
                  //         buffer.writeln(
                  //           '${record.time}: ${(record as OxygenSaturationRecord).percentage}%'
                  //         );
                  //         break;
                  //       case HealthConnectDataType.RespiratoryRate:
                  //         buffer.writeln(
                  //           '${record.time}: ${(record as RespiratoryRateRecord).rate} breaths/min'
                  //         );
                  //         break;
                  //       default:
                  //         buffer.writeln('Unhandled data type: $dataType');
                  //     }
                  //   }
                  //   buffer.writeln('\n');
                  // });

                  // resultText = buffer.toString();
                } catch (e) {
                  resultText = 'Error fetching data: $e';
                }
                _updateResultText();
              },
              child: const Text('Get Health Data'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await HealthConnectFactory.installHealthConnect();
                } catch (e) {
                  resultText = 'Install failed: ${e.toString()}';
                  _updateResultText();
                }
              },
              child: const Text('Install Health Connect'),
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
      ),
    );
  }

  void _updateResultText() {
    setState(() {});
  }
}
