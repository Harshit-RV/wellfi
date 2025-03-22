import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text('Fitness Records')),
      body: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          var record = records[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Record ${index + 1}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(height: 8),
                  Text('Count: ${record['count']}'),
                  Text(
                      'Start Time: ${formatEpoch(record['startTime']['epochSecond'], record['startTime']['nano'])}'),
                  Text(
                      'End Time: ${formatEpoch(record['endTime']['epochSecond'], record['endTime']['nano'])}'),
                  const Divider(),
                  Text('Metadata:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                      'Package: ${record['metadata']['dataOrigin']['packageName']}'),
                  Text('Device Type: ${record['metadata']['device']['type']}'),
                  Text('Record ID: ${record['metadata']['id']}'),
                  Text(
                      'Last Modified: ${formatEpoch(record['metadata']['lastModifiedTime']['epochSecond'], record['metadata']['lastModifiedTime']['nano'])}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
