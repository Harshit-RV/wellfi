// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:wellfi2/components/CustomAppBar.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar('Leaderboard'),
      body: Column(
        children: [
          SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            height: 300,
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    height: 160,
                    color: Colors.red,
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Container(
                    height: 230,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Container(
                    height: 110,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const Text('Leaderboard'),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text((index + 1).toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  title: Text('User ${index + 1}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
