import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:solana_wallet_provider/solana_wallet_provider.dart';
import 'package:wellfi2/constants.dart';
import 'package:wellfi2/firebase_options.dart';
import 'package:wellfi2/layout.dart';
import 'package:wellfi2/pages/LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    SolanaWalletProvider.create(
      identity: const AppIdentity(
        // uri: 'your-app://',
        // icon: 'icon.png',
        name: 'Accountability App',
      ),
      httpCluster: Cluster.devnet,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: const ColorScheme(
            surface: kPrimaryColor,
            secondary: kPrimaryColor,
            onSurface: Colors.black,
            primary: kPrimaryColor,
            background: Colors.black,
            brightness: Brightness.dark,
            error: Colors.red,
            onBackground: Colors.white,
            onError: Colors.white,
            onPrimary: Colors.black,
            onSecondary: Colors.black,
          ),
          useMaterial3: false,
        ),
        home: AuthWrapper(),
      ),
    ),
  );
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return LoginScreen();
          } else {
            return Layout();
          }
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
