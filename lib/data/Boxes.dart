import 'dart:io';

import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';


class Boxes {
  static Box<bool> get favoriteBox =>
      Hive.box<bool>('favorites');


  static Future<void> initHive() async {
   print('init Hive');

   await Hive.initFlutter(await _dbPath());
  
  }
  static Future<String> _dbPath() async {
    // Get the application's document directory
    Directory appDir = await getApplicationDocumentsDirectory();

    // Get the chosen sub-directory for Hive files
    return '${appDir.path}';
  }
  static Future<void> clearDb() async {
     await Hive.close();
    // Directory hiveDb = Directory(await _dbPath());
    // await hiveDb.delete(recursive: true);
    await openBoxes();
  }



  static Future<void> closeDatabase() async {
  

    
      await compactAndCloseBoxes();
    
  }

  static Future<void> compactAndCloseBoxes() async {
    print('Compacting & closing box Favorite');
    await favoriteBox.close();
  }

  static Future<void> openBoxes() async {
    print('hive openBoxes');

    await Hive.openBox<bool>('favorites');
    

  }

}
