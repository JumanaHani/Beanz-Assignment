import 'package:beanz_assessment/core/theme/app_theme.dart';
import 'package:beanz_assessment/data/data_source/remote/book_api_services.dart';
import 'package:beanz_assessment/presentation/Bloc/book_bloc/book_bloc.dart';
import 'package:beanz_assessment/presentation/Bloc/book_bloc/book_event.dart';
import 'package:beanz_assessment/presentation/Bloc/favorite_bloc/favorite_book_bloc.dart';
import 'package:beanz_assessment/presentation/Bloc/favorite_bloc/favorite_book_event.dart';
import 'package:beanz_assessment/data/Boxes.dart';
import 'package:beanz_assessment/presentation/app/book_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Boxes.initHive();
  print("Is favorites box already open? ${Hive.isBoxOpen('favorites')}");
await Boxes.openBoxes();
//  await Hive.openBox('favorites'); // Open the box only once

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                BookBloc(BookApiService())..add(FetchBooksEvent())),
        BlocProvider(create: (_) => FavoriteBloc()..add(LoadFavoritesEvent())),
      ],
      child: MaterialApp(
        title: 'Books App',
        theme: AppTheme.defaultTheme,
        // theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => BooksList(),
          // '/addEdit': (context) => AddEditBookScreen(),
        },
      ),
    );
  }
}
