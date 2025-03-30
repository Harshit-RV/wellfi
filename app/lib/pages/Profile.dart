// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:wellfi2/components/CustomAppBar.dart';
import 'package:wellfi2/constants.dart';
import 'package:wellfi2/controllers/user_controller.dart';
import 'package:wellfi2/pages/FitnessData.dart';

class Profile extends GetView<UserController> {
  Profile({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    controller.getUserData();
    return Scaffold(
      appBar: buildCustomAppBar('Profile'),
      body: Obx(
        () => controller.user.value == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Text(
                      controller.user.value!.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      controller.user.value!.email,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    SizedBox(height: 7),
                    Divider(),
                    SizedBox(height: 12),
                    FutureBuilder(
                      future: SolanaWalletProvider.initialize(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return WalletButton();
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                    SizedBox(height: 7),
                    Divider(),
                    SizedBox(height: 7),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kLighterBackgroundColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppSetup(),
                            ),
                          );
                        },
                        child: Text('App setup'),
                      ),
                    ),
                    SizedBox(height: 7),
                    Divider(),
                    SizedBox(height: 7),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kLighterBackgroundColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _auth.signOut(),
                        child: Text('Sign out'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class WalletButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = SolanaWalletProvider.of(context);

    return FutureBuilder(
      future: SolanaWalletProvider.initialize(),
      builder: (context, snapshot) {
        return Column(
          children: [
            if (provider.connectedAccount == null)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => provider.connect(context),
                  child: const Text('Connect Wallet'),
                ),
              )
            else
              SizedBox(
                height: 160,
                child: Column(
                  children: [
                    ShowPublicKey(),
                    SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kLighterBackgroundColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => provider.disconnect(context),
                        child: const Text('Disconnect Wallet'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class ShowPublicKey extends StatelessWidget {
  ShowPublicKey({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = SolanaWalletProvider.of(context);

    final Pubkey? wallet =
        Pubkey.tryFromBase64(provider.connectedAccount?.address);
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade800,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connected Wallet:',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            wallet.toString(),
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
