import 'dart:convert';

class DataItem<T> {
  final String date;
  final T steps;

  DataItem(this.date, this.steps);
}

class Helper {
  static List<Map<String, int>> extractStepsByDay(String jsonString) {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    final List<dynamic> records = data['records'];

    // Group records by date
    final Map<String, List<Map<String, dynamic>>> recordsByDate = {};

    for (var record in records) {
      final int startTimeEpoch = record['startTime']['epochSecond'];
      final DateTime date =
          DateTime.fromMillisecondsSinceEpoch(startTimeEpoch * 1000);
      final String formattedDate =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      recordsByDate.putIfAbsent(formattedDate, () => []);
      recordsByDate[formattedDate]!.add({
        'startTime': startTimeEpoch,
        'endTime': record['endTime']['epochSecond'],
        'count': record['count'],
      });
    }

    final Map<String, int> stepsByDate = {};

    recordsByDate.forEach((date, dayRecords) {
      // Sort records by start time
      dayRecords.sort((a, b) => a['startTime'].compareTo(b['startTime']));

      // Check for full-day records (typically 86400 seconds in a day)
      final fullDayRecords = dayRecords
          .where((r) =>
                  (r['endTime'] - r['startTime']) >= 86000 // Close to full day
              )
          .toList();

      if (fullDayRecords.isNotEmpty) {
        // If we have a full day record, use that
        stepsByDate[date] = fullDayRecords.first['count'];
      } else {
        // Otherwise, carefully merge partial records
        int totalSteps = 0;
        final Set<int> processedSeconds = {};

        for (final record in dayRecords) {
          final int start = record['startTime'];
          final int end = record['endTime'];
          final int count = record['count'];

          // Calculate how many seconds are already counted
          int overlapSeconds = 0;
          for (int i = start; i < end; i++) {
            if (processedSeconds.contains(i)) {
              overlapSeconds++;
            }
          }

          // Calculate the proportion of new seconds
          final double newProportion = 1 - (overlapSeconds / (end - start));

          // Add proportional steps
          final int newSteps = (count * newProportion).round();
          totalSteps += newSteps;

          // Mark these seconds as processed
          for (int i = start; i < end; i++) {
            processedSeconds.add(i);
          }
        }

        stepsByDate[date] = totalSteps;
      }
    });

    return stepsByDate.entries
        .map((entry) => {entry.key: entry.value})
        .toList();
  }

  static List<DataItem<T>> convertStepsHashmapToKeyedMap<T>(
      List<Map<String, T>> rawData) {
    List<DataItem<T>> result = [];

    for (var entry in rawData) {
      String dateString = entry.keys.first;
      T steps = entry.values.first;

      DateTime date = DateTime.parse(dateString);
      String dayOfWeek = getDayOfWeek(date.weekday);
      print('${date.weekday} $dayOfWeek ${date.day} $dateString');

      result.add(
          DataItem(date.day.toString() + '/' + date.month.toString(), steps));
    }

    return result;
  }

  static String getDayOfWeek(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  static List<Map<String, double>> extractDistanceByDay(String jsonString) {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    final List<dynamic> records = data['records'];

    // Group records by date
    final Map<String, List<Map<String, dynamic>>> recordsByDate = {};

    for (var record in records) {
      final int startTimeEpoch = record['startTime']['epochSecond'];
      final DateTime date =
          DateTime.fromMillisecondsSinceEpoch(startTimeEpoch * 1000);
      final String formattedDate =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      recordsByDate.putIfAbsent(formattedDate, () => []);
      recordsByDate[formattedDate]!.add({
        'startTime': startTimeEpoch,
        'endTime': record['endTime']['epochSecond'],
        'distance': record['distance']['meters'], // Extract meters directly
      });
    }

    final Map<String, double> distanceByDate = {};

    recordsByDate.forEach((date, dayRecords) {
      // Sort records by start time
      dayRecords.sort((a, b) => a['startTime'].compareTo(b['startTime']));

      // Check for full-day records (typically 86400 seconds in a day)
      final fullDayRecords = dayRecords
          .where((r) =>
                  (r['endTime'] - r['startTime']) >= 86000 // Close to full day
              )
          .toList();

      if (fullDayRecords.isNotEmpty) {
        // If we have a full day record, use that
        distanceByDate[date] =
            double.parse(fullDayRecords.first['distance'].toStringAsFixed(1));
      } else {
        // Otherwise, carefully merge partial records
        double totalDistance = 0;
        final Set<int> processedSeconds = {};

        for (final record in dayRecords) {
          final int start = record['startTime'];
          final int end = record['endTime'];
          final double distance = record['distance'];

          // Calculate how many seconds are already counted
          int overlapSeconds = 0;
          for (int i = start; i < end; i++) {
            if (processedSeconds.contains(i)) {
              overlapSeconds++;
            }
          }

          // Calculate the proportion of new seconds
          final double newProportion = 1 - (overlapSeconds / (end - start));

          // Add proportional distance
          final double newDistance = distance * newProportion;
          totalDistance += newDistance;

          // Mark these seconds as processed
          for (int i = start; i < end; i++) {
            processedSeconds.add(i);
          }
        }

        distanceByDate[date] = double.parse(totalDistance.toStringAsFixed(1));
      }
    });

    return distanceByDate.entries
        .map((entry) => {entry.key: entry.value})
        .toList();
  }
}
