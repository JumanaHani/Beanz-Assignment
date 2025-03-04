import 'dart:io';

import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';

class Boxes {
  static Box<bool>? favoriteBox; // Make it nullable to handle cases when it's not yet opened

  static Box<bool> get favoriteBoxInstance {
    if (favoriteBox == null) {
      throw Exception('Hive box not initialized. Call openBoxes() first.');
    }
    return favoriteBox!;
  }

  static Future<void> initHive() async {
    print('init Hive');
    // Initialize Hive and provide a path
    await Hive.initFlutter(await _dbPath());
  }

  static Future<String> _dbPath() async {
    // Get the application's document directory
    Directory appDir = await getApplicationDocumentsDirectory();
    // Return the directory path for Hive files
    return appDir.path;
  }

  // Method to clear the database by closing boxes and optionally clearing data
  static Future<void> clearDb() async {
    print('Clearing DB...');
    await compactAndCloseBoxes();
    // Optionally, delete files or reset the boxes here
    await openBoxes(); // Reopen boxes after clearing if needed
  }

  // Method to close the database and compact it
  static Future<void> closeDatabase() async {
    print('Closing Hive DB...');
    await compactAndCloseBoxes();
  }

  // Compact and close all boxes
  static Future<void> compactAndCloseBoxes() async {
    print('Compacting & closing box Favorite');
    await favoriteBox?.close();
    favoriteBox = null; // Ensure the box is not reused unintentionally
  }

  // Method to open boxes (ensure they are opened properly)
  static Future<void> openBoxes() async {
    print('Opening Hive Boxes...');
    favoriteBox = await Hive.openBox<bool>('favorites');
  }
}
