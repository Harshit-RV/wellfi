import 'package:flutter/material.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';

class WalletConnect extends StatelessWidget {
  const WalletConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: SolanaWalletProvider.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return WalletButton();
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
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
              ElevatedButton(
                onPressed: () => provider.connect(context),
                child: const Text('Connect Wallet'),
              )
            else
              Column(
                children: [
                  Text('Connected: ${provider.connectedAccount!.address}'),
                  ElevatedButton(
                    onPressed: () => provider.disconnect(context),
                    child: const Text('Disconnect'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final Pubkey? wallet = Pubkey.tryFromBase64(
                          provider.connectedAccount?.address);
                      print(wallet);
                    },
                    child: const Text('print address'),
                  )
                ],
              ),
          ],
        );
      },
    );
  }
}
