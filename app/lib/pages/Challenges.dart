// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wellfi2/components/CustomAppBar.dart';
import 'package:wellfi2/components/challenge_widget.dart';
import 'package:wellfi2/models/Challenge.dart';
import 'package:wellfi2/services/challenge_service.dart';

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

  FirebaseAuth _auth = FirebaseAuth.instance;

  List<Challenge> _challenges = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252525),
      appBar: buildCustomAppBar('Challenges'),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              String authToken = await _auth.currentUser!.getIdToken() ?? '';
              var list = await ChallengeService.getPublicChallenges(
                  authToken: authToken);
              print(list);

              setState(() {
                _challenges = list;
              });
            },
            child: Text("something"),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(
                top: 18,
                left: 10,
                right: 10,
                bottom: 14,
              ),
              physics: BouncingScrollPhysics(),
              itemCount: _challenges.length,
              itemBuilder: (context, index) {
                return ChallengeWidget(
                  title: _challenges[index].title,
                  goal: _challenges[index].desc,
                  price: _challenges[index].requiredStake,
                  participants: _challenges[index].participants.length,
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
