import 'package:flutter/material.dart';
import 'package:wellfi2/components/CustomAppBar.dart';
import 'package:wellfi2/constants.dart';

class Friends extends StatelessWidget {
  const Friends({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for friends
    final List<Map<String, dynamic>> friends = [
      {'name': 'Alice', 'initials': 'A', 'steps': 5000},
      {'name': 'Bob', 'initials': 'B', 'steps': 7000},
      {'name': 'Charlie', 'initials': 'C', 'steps': 3000},
      {'name': 'Diana', 'initials': 'D', 'steps': 8000},
      {'name': 'Eve', 'initials': 'E', 'steps': 6000},
    ];
    final TextEditingController searchController = TextEditingController();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: buildCustomAppBar('Friends'),
        body: Column(
          children: [
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.shade800,
                ),
              ),
              child: const TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white,
                tabs: [
                  Tab(child: Text('Friends')),
                  Tab(child: Text('Discover')),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: searchController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: Icon(Icons.people, color: Colors.grey.shade400),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade800),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Add email validation
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10),
            // Friends List
            Expanded(
              child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(friend['initials']),
                    ),
                    title: Text(friend['name']),
                    subtitle: Text('Steps: ${friend['steps']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.person_add),
                      onPressed: () {
                        // Handle add friend logic here
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('${friend['name']} added as a friend!')),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
