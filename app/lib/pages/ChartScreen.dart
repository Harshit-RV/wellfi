import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StepsChartScreen extends StatelessWidget {
  StepsChartScreen({Key? key}) : super(key: key);

  final List<int> stepCounts = [3000, 6041, 5000, 4000, 4500, 5000, 0];
  final List<double> stepDistances = [2.0, 3.83, 3.2, 2.5, 2.8, 3.0, 0.0];
  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Steps',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This Week',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 20),
            _buildSegmentedControl(),
            const SizedBox(height: 20),
            _buildStepCountChart(),
            const SizedBox(height: 20),
            _buildStepDistanceChart(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.bar_chart, color: Colors.black, size: 30),
            Icon(Icons.people, color: Colors.black, size: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSegmentButton('D'),
        _buildSegmentButton('W', isSelected: true),
        _buildSegmentButton('M'),
        _buildSegmentButton('Y'),
      ],
    );
  }

  Widget _buildSegmentButton(String label, {bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: isSelected ? 8.0 : 6.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey.shade200 : Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildStepCountChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COUNT',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        const SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 1.5,
          child: BarChart(
            BarChartData(
              barGroups: stepCounts.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.toDouble(),
                      color: Colors.purple,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }).toList(),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        days[value.toInt()],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              maxY: 10000,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepDistanceChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DISTANCE',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        const SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 1.5,
          child: BarChart(
            BarChartData(
              barGroups: stepDistances.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value,
                      color: Colors.blue,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }).toList(),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        days[value.toInt()],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(show: false),
              borderData: FlBorderData(show: false),
              maxY: 5,
            ),
          ),
        ),
      ],
    );
  }
}
