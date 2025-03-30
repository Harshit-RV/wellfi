import 'package:flutter/material.dart';
import 'package:wellfi2/components/CustomAppBar.dart';

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

    return Scaffold(
      appBar: buildCustomAppBar('Friends'),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search people...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                // Handle search logic here
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
    );
  }
}
