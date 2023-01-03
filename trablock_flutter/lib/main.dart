import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/provider/AddPlanViewProvider.dart';
import 'package:trablock_flutter/src/provider/AddTravelViewProvider.dart';
import 'package:trablock_flutter/src/provider/AuthProvider.dart';
import 'package:trablock_flutter/src/provider/PlanDragStateProvider.dart';
import 'package:trablock_flutter/src/provider/SelectedTravelProvider.dart';
import 'package:trablock_flutter/src/provider/TravelProvider.dart';
import 'package:trablock_flutter/src/provider/UserProvider.dart';
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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
          ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
          ChangeNotifierProvider<TravelProvider>(create: (_) => TravelProvider()),
          ChangeNotifierProvider<SelectedTravelProvider>(create: (_) => SelectedTravelProvider()),
          ChangeNotifierProvider<PlanDragStateProvider>(create: (_) => PlanDragStateProvider()),
          ChangeNotifierProvider<AddPlanViewProvider>(create: (_) => AddPlanViewProvider()),
          ChangeNotifierProvider<AddTravelViewProvider>(create: (_) => AddTravelViewProvider()),
        ],
        child: MaterialApp(
          title: 'Trablock',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          home: const RoutingView(),
      )
    );
  }
}