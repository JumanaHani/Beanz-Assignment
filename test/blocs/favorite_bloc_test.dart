import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:beanz_assessment/presentation/Bloc/favorite_bloc/favorite_book_bloc.dart';
import 'package:beanz_assessment/presentation/Bloc/favorite_bloc/favorite_book_event.dart';
import 'package:beanz_assessment/presentation/Bloc/favorite_bloc/favorite_book_state.dart';

// ✅ Mock for Hive Box
class MockHiveBox extends Mock implements Box<bool> {}

// ✅ Fake PathProvider Implementation
class FakePathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String> getApplicationDocumentsPath() async {
    final directory = Directory.systemTemp.createTempSync();
    return directory.path;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // ✅ Ensures Flutter Services

  late FavoriteBloc favoriteBloc;
  late Box<bool> favoriteBox;

  setUpAll(() async {
    // ✅ Use a Fake PathProvider for testing
    PathProviderPlatform.instance = FakePathProviderPlatform();

    //  Initialize Hive with a temporary directory
    final directory = await getApplicationDocumentsDirectory(); // Get Directory
    Hive.init(directory.path); // ✅ Extract the path string

    // ✅ Open a test Hive box
    await Hive.openBox<bool>('favorites');
  });

  setUp(() {
    favoriteBox = Hive.box<bool>('favorites');
    favoriteBloc = FavoriteBloc();
  });

  tearDown(() async {
    await favoriteBox.clear();
    await favoriteBloc.close();
  });

  test('initial state is FavoriteInitial', () {
    expect(favoriteBloc.state, isA<FavoriteInitial>());
  });

  test('should load favorites correctly', () async {
    await favoriteBox.put('book1', true);

    favoriteBloc.add(LoadFavoritesEvent());
    await Future.delayed(Duration.zero);

    expect(
      favoriteBloc.state,
      isA<FavoriteLoaded>()
          .having((state) => state.favorites, 'favorites', {'book1': true}),
    );
  });

  test('should add book to favorites if not already in favorites', () async {
    favoriteBloc.add(ToggleFavoriteEvent('book2'));
    await Future.delayed(Duration.zero);

    expect(favoriteBox.get('book2'), true);
  });
}
