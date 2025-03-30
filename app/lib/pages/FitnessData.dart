import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:wellfi2/components/CustomAppBar.dart';
import 'package:wellfi2/constants.dart';
import 'package:wellfi2/layout.dart';

class AppSetup extends StatefulWidget {
  const AppSetup({super.key});

  @override
  State<AppSetup> createState() => _AppSetupState();
}

class _AppSetupState extends State<AppSetup> {
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

  @override
  void initState() {
    super.initState();
    _runSetup();
  }

  Future<void> _runSetup() async {
    if (!await HealthConnectFactory.isApiSupported()) {
      setState(() => resultText = 'Health Connect API not supported');
      return;
    }

    if (!await HealthConnectFactory.isAvailable()) {
      setState(
          () => resultText = 'Health Connect not installed. Installing...');
      await HealthConnectFactory.installHealthConnect();
      return;
    }

    if (!await HealthConnectFactory.hasPermissions(types, readOnly: readOnly)) {
      setState(() => resultText = 'Requesting permissions...');
      bool granted = await HealthConnectFactory.requestPermissions(types,
          readOnly: readOnly);
      if (!granted) {
        setState(() =>
            resultText = 'Permissions not granted. Please enable in settings.');
        return;
      }
    }

    await _fetchHealthData();
  }

  Future<void> _fetchHealthData() async {
    try {
      final startTime = DateTime.now().subtract(const Duration(days: 3));
      final endTime = DateTime.now();
      final results = await HealthConnectFactory.getRecord(
        type: HealthConnectDataType.Steps,
        startTime: startTime,
        endTime: endTime,
      );
      setState(() {
        resultText = "Good to go!";
        data = results;
      });
    } catch (e) {
      log(e.toString());
      setState(() => resultText = 'Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar('Health Connect'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: resultText == "Good to go!"
            ? Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "All Checks Passed!",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 13),
                        Text(
                          resultText,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Make sure to add your primary Health app to the Health Connect app. This will allow you to sync your data across different apps and devices.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kLighterBackgroundColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        await HealthConnectFactory.openHealthConnectSettings();
                      },
                      child: Text('Open Health Connect Settings'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Layout()),
                          (route) => false,
                        );
                      },
                      child: Text('Home'),
                    ),
                  ),
                ],
              )
            : SelectableText(
                resultText,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
      ),
    );
  }
}

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_health_connect/flutter_health_connect.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:wellfi2/components/CustomAppBar.dart';

// class AppSetup extends StatefulWidget {
//   const AppSetup({super.key});

//   @override
//   State<AppSetup> createState() => _AppSetupState();
// }

// class _AppSetupState extends State<AppSetup> {
//   List<HealthConnectDataType> types = [
//     HealthConnectDataType.Power,
//     HealthConnectDataType.Distance,
//     HealthConnectDataType.Steps,
//     HealthConnectDataType.TotalCaloriesBurned,
//     HealthConnectDataType.HeartRate,
//     HealthConnectDataType.SleepSession,
//     HealthConnectDataType.OxygenSaturation,
//     HealthConnectDataType.RespiratoryRate,
//   ];

//   bool readOnly = false;
//   Map<String, dynamic> data = {};
//   String resultText = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildCustomAppBar('Health Connect'),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           ElevatedButton(
//             onPressed: () async {
//               var result = await HealthConnectFactory.isApiSupported();
//               resultText = 'isApiSupported: $result';
//               _updateResultText();
//             },
//             child: const Text('Check API Support'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               var result = await HealthConnectFactory.isAvailable();
//               resultText = 'isAvailable: $result';
//               _updateResultText();
//             },
//             child: const Text('Check Installed'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               await HealthConnectFactory.installHealthConnect();
//             },
//             child: const Text('Install Health Connect'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               await HealthConnectFactory.openHealthConnectSettings();
//             },
//             child: const Text('Open Settings'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               var result = await HealthConnectFactory.hasPermissions(
//                 types,
//                 readOnly: readOnly,
//               );
//               resultText = 'hasPermissions: $result';
//               _updateResultText();
//             },
//             child: const Text('Check Permissions'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               var result = await HealthConnectFactory.requestPermissions(
//                 types,
//                 readOnly: readOnly,
//               );
//               resultText = 'requestPermissions: $result';
//               _updateResultText();
//             },
//             child: const Text('Request Permissions'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               try {
//                 if (!await HealthConnectFactory.hasPermissions(types,
//                     readOnly: true)) {
//                   resultText = 'Please grant permissions first';
//                   _updateResultText();
//                   return;
//                 }

//                 final startTime =
//                     DateTime.now().subtract(const Duration(days: 3));
//                 final endTime = DateTime.now();

//                 // no data: blood pressure, active calories burned, ElevationGained, ExerciseSession, FloorsClimbed, HeartRate
//                 // yes data: distance, calories, steps, Height, Weight
//                 final results = await HealthConnectFactory.getRecord(
//                   type: HealthConnectDataType.Steps,
//                   startTime: startTime,
//                   endTime: endTime,
//                 );

//                 // log(results.toString());

//                 // final buffer = StringBuffer();
//                 // results.forEach((dataType, records) {
//                 //   for (final record in records) {
//                 //     buffer.writeln('${record}: ${record} steps');
//                 //   }
//                 //   buffer.writeln('\n');
//                 // });

//                 setState(() {
//                   // resultText = buffer.toString();

//                   resultText = results.toString();
//                   data = results;
//                 });
//               } catch (e) {
//                 log(e.toString());
//                 resultText = 'Error fetching data: $e';
//               }
//               _updateResultText();
//             },
//             child: const Text('Get Health Data'),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SelectableText(
//               resultText,
//               style: const TextStyle(fontFamily: 'monospace'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _updateResultText() {
//     setState(() {});
//   }
// }

// class StepData {
//   final String day;
//   final int steps;

//   StepData(this.day, this.steps);
// }

// class StepDistanceData {
//   final String day;
//   final double distance;

//   StepDistanceData(this.day, this.distance);
// }
