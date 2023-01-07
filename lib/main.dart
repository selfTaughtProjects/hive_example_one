import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import './page/first_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('shopping_box');
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {

  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  FristScreen(),
    );
  }
}
