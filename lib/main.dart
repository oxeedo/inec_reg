import 'package:flutter/material.dart';
import 'package:inec_reg/homescreen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:inec_reg/screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final backgroundColor = Color.fromARGB(255, 199, 194, 194);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.white),
      home: HomeScreen(),
    );
  }
}
