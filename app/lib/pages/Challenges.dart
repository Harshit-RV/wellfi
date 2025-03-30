// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
// import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:wellfi2/components/CustomAppBar.dart';
import 'package:wellfi2/components/challenge_widget.dart';
import 'package:wellfi2/controllers/challenge_controller.dart';

class Challenges extends GetView<ChallengeController> {
  Challenges({super.key});

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
                  ElevatedButton(
                    onPressed: () async {
                      // Load your contract's IDL (typically a JSON file)
                      // final idl = await loadIdlFromFile('path_to_idl.json');

                      // // Create an Anchor program instance
                      // final program = AnchorProgram(
                      //   idl: idl,
                      //   programId: Ed25519HDPublicKey.fromBase58(
                      //       'Your_Contract_Address'),
                      //   client: client,
                      // );

                      // // Call a function on your contract
                      // final result = await program.rpc.yourFunctionName(
                      //   // Function arguments
                      //   [arg1, arg2],
                      //   // Accounts required by the function
                      //   accounts: {
                      //     'account1': account1PublicKey,
                      //     'account2': account2PublicKey,
                      //   },
                      //   // Signers
                      //   signers: [keypair],
                      // );

                      // print('Function called successfully: $result');
                    },
                    child: Text('Create'),
                  ),
                  FutureBuilder(
                    future: SolanaWalletProvider.initialize(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SolanaTransaction();
                      }
                      return CircularProgressIndicator();
                    },
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

class SolanaTransaction extends StatelessWidget {
  const SolanaTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = SolanaWalletProvider.of(context);

    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            try {
              print("Preparing transaction...");

              final connection = provider.connection;

              final userPublicKey =
                  Pubkey.fromBase64(provider.adapter.connectedAccount!.address);
              final Uint8List transactionBytes = base64Decode(
                  'AQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAEDRCPJ9P7uFxfM6EL640IlpErAeIXZgCZRfh82+clYa+Dl9UzkNKnMGwhixSRyutMrMtFFbd8nGqrsQcIlSA2JugAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAyonsethLkdt2P3P/Ak2p9ikv4GSgv4wmO+tOrDRYfCABAgIAAQwCAAAAAOH1BQAAAAA=');

              final Transaction oldTransaction =
                  Transaction.deserialize(transactionBytes);

              Map<String, dynamic> transactionJson = oldTransaction.toJson();

              final blockhashResponse = await connection.getLatestBlockhash();
              transactionJson['message']['recentBlockhash'] =
                  blockhashResponse.blockhash;

              log(blockhashResponse.blockhash);

              final Transaction transaction =
                  Transaction.fromJson(transactionJson);

              log(jsonEncode(oldTransaction));
              log(jsonEncode(transaction));

              if (provider.isAuthorized) {
                log('not authorised');
              }

              // Sign and send the transaction
              final result = await provider.signAndSendTransactions(
                context,
                transactions: [transaction],
              );
            } catch (e) {
              log(e.toString());
              // setState(() => _status = "Transaction error: $e");
            }
          },
          child: Text('do it'),
        ),
      ],
    );
  }
}
