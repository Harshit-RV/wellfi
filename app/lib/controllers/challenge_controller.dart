import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wellfi2/models/Challenge.dart';
import 'package:wellfi2/services/challenge_service.dart';

class ChallengeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxList<Challenge> challenges = <Challenge>[].obs;
  final RxBool loading = false.obs;

  Future<void> getChallenges() async {
    loading.value = true;
    String authToken = await _auth.currentUser!.getIdToken() ?? '';
    challenges.value =
        await ChallengeService.getPublicChallenges(authToken: authToken);
    loading.value = false;
  }
}
