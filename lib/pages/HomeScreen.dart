import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Fitbit Premium"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
          TextButton(
            onPressed: () {},
            child: const Text("Edit"),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 10.0,
              percent: 0.7,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("70",
                      style: GoogleFonts.poppins(
                          fontSize: 30, fontWeight: FontWeight.bold)),
                  const Text("Zone Mins",
                      style: TextStyle(color: Colors.white70))
                ],
              ),
              progressColor: Colors.yellowAccent,
              backgroundColor: Colors.grey[800]!,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard("919", "Steps", Colors.green),
              _buildStatCard("0.65", "KM", Colors.blue),
              _buildStatCard("800", "Cals", Colors.red),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                _buildTaskItem("75 Stress Management", "Calm at 2:59 PM"),
                _buildTaskItem("6 Hr 16 Min", "Calm at 2:59 PM",
                    hasSubtasks: true),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: () {}),
            IconButton(
                icon: const Icon(Icons.swap_horiz, color: Colors.white),
                onPressed: () {}),
            const SizedBox(width: 40),
            IconButton(
                icon: const Icon(Icons.grid_view, color: Colors.white),
                onPressed: () {}),
            IconButton(
                icon: const Icon(Icons.star, color: Colors.white),
                onPressed: () {}),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellowAccent,
        child: const Icon(Icons.checkroom, color: Colors.black),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(Icons.circle, color: color),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, String subtitle,
      {bool hasSubtasks = false}) {
    return Card(
      color: Colors.black54,
      child: ListTile(
        title: Text(title, style: GoogleFonts.poppins(fontSize: 16)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        trailing: hasSubtasks
            ? const Icon(Icons.remove, color: Colors.white)
            : const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
