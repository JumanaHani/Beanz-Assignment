import 'package:beanz_assessment/data/data_source/remote/book_api_services.dart';
import 'package:beanz_assessment/presentation/Bloc/bloc/book_bloc.dart';
import 'package:beanz_assessment/presentation/Bloc/bloc/book_event.dart';
import 'package:beanz_assessment/presentation/app/book_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('favorites');

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
        // //  // BlocProvider(create: (_) => FavoriteBloc()..add(LoadFavoritesEvent())),
      ],
      child: MaterialApp(
        title: 'Books App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => BooksList(),
          // '/addEdit': (context) => AddEditBookScreen(),
        },
      ),
    );
  }
}
