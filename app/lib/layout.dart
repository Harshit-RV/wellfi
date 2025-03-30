import 'package:flutter/material.dart';
import 'package:wellfi2/constants.dart';
import 'package:wellfi2/pages/Challenges.dart';
import 'package:wellfi2/pages/Charts.dart';
import 'package:wellfi2/pages/FitnessData.dart';
import 'package:wellfi2/pages/Friends.dart';
import 'package:wellfi2/pages/HomeScreen.dart';
import 'package:wellfi2/pages/Leaderboard.dart';
import 'package:wellfi2/pages/Profile.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int currentPageIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: kLighterBackgroundColor,
        indicatorColor: kPrimaryColor,
        height: 70,
        destinations: [
          _buildNavItem(Icons.home, "Home", 0),
          _buildNavItem(Icons.group, "Friends", 1),
          _buildNavItem(Icons.thunderstorm, "Challenges", 2),
          _buildNavItem(Icons.leaderboard, "Leaderboard", 3),
          _buildNavItem(Icons.person, "Profile", 4),
        ],
        selectedIndex: currentPageIndex,
      ),
      body: [
        HomeScreen(),
        StepsChartScreenS(),
        // StepsChartApp(),
        Challenges(),
        Leaderboard(),
        Profile(),
      ][currentPageIndex],
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = currentPageIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          currentPageIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: isSelected ? kPrimaryColor : Colors.transparent,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? kPrimaryColor : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
