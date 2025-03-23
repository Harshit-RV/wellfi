import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wellfi2/constants.dart';
import 'package:wellfi2/pages/Challenges.dart';
import 'package:wellfi2/pages/HomeScreen.dart';
import 'package:wellfi2/pages/Leaderboard.dart';
import 'package:wellfi2/pages/WalletConnect.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Color(0xFF3B3B3B),
        indicatorColor: kPrimaryColor,
        height: 70,
        destinations: [
          _buildNavItem(Icons.home, "Home", 0),
          _buildNavItem(Icons.thunderstorm, "Challenges", 1),
          _buildNavItem(Icons.wallet, "Home", 2),
          _buildNavItem(Icons.leaderboard, "Leaderboard", 3),
          _buildNavItem(Icons.person, "Profile", 4),

          // NavigationDestination(
          //   icon: Icon(Icons.person, color: Colors.white),
          //   label: 'Rewards',
          // ),
        ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          if (mounted) {
            setState(() {
              currentPageIndex = index;
            });
          }
        },
      ),
      body: [
        HomeScreen(),
        Challenges(),
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

//  bottomNavigationBar: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           Container(
//             height: 70,
//             decoration: const BoxDecoration(
//               color: Colors.black,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(25),
//                 topRight: Radius.circular(25),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildNavItem(Icons.home, "Home", 0),
//                 _buildNavItem(Icons.local_fire_department, "Matches", 1),
//                 // SizedBox(width: 50), // Space for floating button
//                 _buildNavItem(Icons.emoji_events, "Leaders", 3),
//                 _buildNavItem(Icons.card_giftcard, "Rewards", 4),
//               ],
//             ),
//           ),
//         ],
//       ),