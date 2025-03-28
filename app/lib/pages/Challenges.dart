// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:wellfi2/components/CustomAppBar.dart';

class Challenges extends StatefulWidget {
  const Challenges({super.key});

  @override
  State<Challenges> createState() => _ChallengesState();
}

class _ChallengesState extends State<Challenges> {
  List challenges = [
    {
      'title': 'Walk 10,000 steps daily',
      'goal': 'Walk 10,000 steps daily for 30 days',
      'price': 10.0,
      'participants': 5,
    },
    {
      'title': 'Run 5 KM daily',
      'goal': 'Run 5 KM daily for 30 days',
      'price': 20.0,
      'participants': 3,
    },
    {
      'title': 'Burn 500 calories daily',
      'goal': 'Burn 500 calories daily for 30 days',
      'price': 1.05,
      'participants': 4,
    },
    {
      'title': 'Run 5 KM daily',
      'goal': 'Run 5 KM daily for 30 days',
      'price': 20.0,
      'participants': 3,
    },
    {
      'title': 'Burn 500 calories daily',
      'goal': 'Burn 500 calories daily for 30 days',
      'price': 1.05,
      'participants': 4,
    },
    {
      'title': 'Run 5 KM daily',
      'goal': 'Run 5 KM daily for 30 days',
      'price': 20.0,
      'participants': 3,
    },
    {
      'title': 'Burn 500 calories daily',
      'goal': 'Burn 500 calories daily for 30 days',
      'price': 1.05,
      'participants': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252525),
      appBar: buildCustomAppBar('Challenges'),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(
                top: 18,
                left: 10,
                right: 10,
                bottom: 14,
              ),
              physics: BouncingScrollPhysics(),
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                return ChallengeWidget(
                  title: challenges[index]['title'],
                  goal: challenges[index]['goal'],
                  price: challenges[index]['price'],
                  participants: challenges[index]['participants'],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class ChallengeWidget extends StatelessWidget {
  const ChallengeWidget({
    super.key,
    required this.title,
    required this.goal,
    required this.price,
    required this.participants,
  });

  final String title;
  final String goal;
  final double price;
  final int participants;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade800),
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            goal,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF454545),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    Icon(Icons.people),
                    const SizedBox(width: 5),
                    Text(
                      participants.toString(),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                onPressed: () {},
                child: Text('Join for $price\$'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
