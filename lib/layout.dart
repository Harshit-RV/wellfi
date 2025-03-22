import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wellfi2/constants.dart';
import 'package:wellfi2/pages/Challenges.dart';
import 'package:wellfi2/pages/HomeScreen.dart';

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
        // backgroundColor: Color(0xFF3B3B3B),
        // indicatorColor: kPrimaryColor,
        height: 70,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.fire_truck, color: Colors.white),
            label: 'My Matches',
          ),
          NavigationDestination(
            icon: Icon(Icons.wallet, color: Colors.white),
            label: 'Variations',
          ),
          NavigationDestination(
            icon: Icon(Icons.person, color: Colors.white),
            label: 'Leaders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person, color: Colors.white),
            label: 'Rewards',
          ),
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
        Challenges(),
        Challenges(),
      ][currentPageIndex],
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