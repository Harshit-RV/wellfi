import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wellfi2/constants.dart';
import 'package:wellfi2/pages/HomeScreen.dart';

class FitnessRecordsWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const FitnessRecordsWidget({super.key, required this.data});

  String formatEpoch(int epochSecond, int nano) {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(epochSecond * 1000).toLocal();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    List records = data['records'] ?? [];

    // Process the records to extract step count and distance per day
    Map<String, int> stepCounts = {};
    Map<String, double> stepDistances = {};

    for (var record in records) {
      String day = DateFormat('EEE').format(DateTime.fromMillisecondsSinceEpoch(
              record['startTime']['epochSecond'] * 1000)
          .toLocal());

      stepCounts[day] =
          ((stepCounts[day] ?? 0) + (record['count'] ?? 0)).toInt();
      stepDistances[day] =
          (stepDistances[day] ?? 0.0) + (record['distance'] ?? 0.0);
    }

    List<StepData> stepCountData =
        stepCounts.entries.map((e) => StepData(e.key, e.value)).toList();

    List<StepDistanceData> stepDistanceData = stepDistances.entries
        .map((e) => StepDistanceData(e.key, e.value))
        .toList();

    stepCountData.map((e) {
      print('${e.day} ${e.steps}');
    }).toList();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Step Count and Distance',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
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
                ColumnSeries<StepData, String>(
                  dataSource: stepCountData,
                  xValueMapper: (StepData data, _) => data.day,
                  yValueMapper: (StepData data, _) => data.steps,
                  color: kPrimaryColor,
                  // dataLabe ttings(isVisible: true, color: Colors.white),
                  enableTooltip: true, // Show tooltip on tap
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
          // const SizedBox(height: 20),
          // Container(
          //   height: 200,
          //   decoration: BoxDecoration(
          //     color: Colors.black.withOpacity(0.5),
          //     borderRadius: BorderRadius.all(Radius.circular(14)),
          //   ),
          //   padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
          //   child: SfCartesianChart(
          //     primaryXAxis: CategoryAxis(
          //       axisLine: AxisLine(color: Colors.white),
          //       labelStyle: TextStyle(color: Colors.white),
          //     ),
          //     primaryYAxis: NumericAxis(
          //       axisLine: AxisLine(color: Colors.white),
          //       labelStyle: TextStyle(color: Colors.white),
          //     ),
          //     series: <CartesianSeries>[
          //       ColumnSeries<StepDistanceData, String>(
          //         dataSource: stepDistanceData,
          //         xValueMapper: (StepDistanceData data, _) => data.day,
          //         yValueMapper: (StepDistanceData data, _) => data.distance,
          //         color: Colors.blue,
          //       ),
          //     ],
          //   ),
          // ),

          // Expanded(
          //   child: ListView.builder(
          //     itemCount: records.length,
          //     itemBuilder: (context, index) {
          //       var record = records[index];
          //       if (record['metadata']['dataOrigin']['packageName'] ==
          //           'com.google.android.apps.fitness') {
          //         return const SizedBox.shrink();
          //       }
          //       return Card(
          //         margin: const EdgeInsets.all(8.0),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(12.0),
          //         ),
          //         elevation: 4,
          //         child: Padding(
          //           padding: const EdgeInsets.all(16.0),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 'Record ${index + 1}',
          //                 style: Theme.of(context).textTheme.headline6,
          //               ),
          //               const SizedBox(height: 8),
          //               Text('Count: ${record['count']}'),
          //               Text(
          //                   'Start Time: ${formatEpoch(record['startTime']['epochSecond'], record['startTime']['nano'])}'),
          //               Text(
          //                   'End Time: ${formatEpoch(record['endTime']['epochSecond'], record['endTime']['nano'])}'),
          //               // const Divider(),
          //               // Text('Metadata:',
          //               //     style: TextStyle(fontWeight: FontWeight.bold)),
          //               Text(
          //                   'Package: ${record['metadata']['dataOrigin']['packageName']}'),
          //               Text(
          //                   'Device Type: ${record['metadata']['device']['type']}'),
          //               Text('Record ID: ${record['metadata']['id']}'),
          //               // Text(
          //               //     'Last Modified: ${formatEpoch(record['metadata']['lastModifiedTime']['epochSecond'], record['metadata']['lastModifiedTime']['nano'])}'),
          //             ],
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // )
        ],
      ),
    );
  }
}

class StepDistanceData {
  final String day;
  final double distance;

  StepDistanceData(this.day, this.distance);
}
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class FitnessRecordsWidget extends StatelessWidget {
//   final Map<String, dynamic> data;

//   const FitnessRecordsWidget({super.key, required this.data});

//   String formatEpoch(int epochSecond, int nano) {
//     final dateTime =
//         DateTime.fromMillisecondsSinceEpoch(epochSecond * 1000).toLocal();
//     return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
//   }

//   @override
//   Widget build(BuildContext context) {
//     List records = data['records'] ?? [];

//     return Scaffold(
//       appBar: AppBar(title: const Text('Fitness Records')),
//       body: ListView.builder(
//         itemCount: records.length,
//         itemBuilder: (context, index) {
//           var record = records[index];
//           return Card(
//             margin: const EdgeInsets.all(8.0),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12.0),
//             ),
//             elevation: 4,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Record ${index + 1}',
//                     style: Theme.of(context).textTheme.headline6,
//                   ),
//                   const SizedBox(height: 8),
//                   Text('Count: ${record['count']}'),
//                   Text(
//                       'Start Time: ${formatEpoch(record['startTime']['epochSecond'], record['startTime']['nano'])}'),
//                   Text(
//                       'End Time: ${formatEpoch(record['endTime']['epochSecond'], record['endTime']['nano'])}'),
//                   const Divider(),
//                   Text('Metadata:',
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   Text(
//                       'Package: ${record['metadata']['dataOrigin']['packageName']}'),
//                   Text('Device Type: ${record['metadata']['device']['type']}'),
//                   Text('Record ID: ${record['metadata']['id']}'),
//                   Text(
//                       'Last Modified: ${formatEpoch(record['metadata']['lastModifiedTime']['epochSecond'], record['metadata']['lastModifiedTime']['nano'])}'),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
