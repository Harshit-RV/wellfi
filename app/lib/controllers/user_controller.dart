import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wellfi2/models/UserModel.dart';
import 'package:wellfi2/services/user_service.dart';

class UserController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool loading = false.obs;

  Future<void> getUserData() async {
    loading.value = true;
    String authToken = await _auth.currentUser!.getIdToken() ?? '';
    var userData = await UserService.getUserData(
        authToken: authToken, id: _auth.currentUser!.uid);
    log(userData.toString());
    user.value = UserModel.fromJson(userData);
    loading.value = false;
  }
}
