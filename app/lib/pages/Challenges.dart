// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wellfi2/components/CustomAppBar.dart';
import 'package:wellfi2/components/challenge_widget.dart';
import 'package:wellfi2/controllers/challenge_controller.dart';

class Challenges extends GetView<ChallengeController> {
  const Challenges({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChallengeController());
    controller.getChallenges();
    return Scaffold(
      backgroundColor: Color(0xFF252525),
      appBar: buildCustomAppBar('Challenges'),
      body: Obx(
        () => controller.loading.value == true
            ? Center(child: CircularProgressIndicator())
            : Column(
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
                      itemCount: controller.challenges.length,
                      itemBuilder: (context, index) {
                        return ChallengeWidget(
                          title: controller.challenges[index].title,
                          goal: controller.challenges[index].desc,
                          price: controller.challenges[index].requiredStake,
                          participants:
                              controller.challenges[index].participants.length,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 14),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
