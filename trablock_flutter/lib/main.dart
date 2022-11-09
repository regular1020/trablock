import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/provider/AuthProvider.dart';
import 'package:trablock_flutter/src/provider/UserProvider.dart';
import 'package:trablock_flutter/src/view/LoginView.dart';
import 'package:trablock_flutter/src/view/RoutingView.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trablock',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
          ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider())
        ],
        child: RoutingView(),
      )
    );
  }
}
