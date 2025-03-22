import 'package:flutter/material.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'dart:developer';

import 'package:wellfi2/comp.dart';
import 'package:wellfi2/constants.dart';
import 'package:wellfi2/layout.dart';
import 'package:wellfi2/pages/Challenges.dart';
import 'package:wellfi2/pages/HomeScreen.dart';
import 'package:wellfi2/pages/WalletConnect.dart';

void main() {
  // runApp(const MyApp());
  runApp(
    SolanaWalletProvider.create(
      identity: const AppIdentity(
        // uri: 'your-app://',
        // icon: 'icon.png',
        name: 'Accountability App',
      ),
      httpCluster: Cluster.devnet,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          surface: kPrimaryColor,
          secondary: kPrimaryColor,
          onSurface: Colors.black,
          primary: kPrimaryColor,
          background: Colors.black,
          brightness: Brightness.dark,
          error: Colors.red,
          onBackground: Colors.white,
          onError: Colors.white,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
        ),
        useMaterial3: false,
      ),
      home: const Layout(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return Scaffold(
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
                MaterialPageRoute(builder: (context) => Challenges()),
              );
            },
            child: const Text('challenges'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
            child: const Text('wallet connect'),
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
                  type: HealthConnectDataType.Power,
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
