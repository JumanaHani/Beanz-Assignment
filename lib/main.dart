
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';



void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<bool>('favorites'); 
  runApp(MaterialApp(home: const Scaffold()));
}

