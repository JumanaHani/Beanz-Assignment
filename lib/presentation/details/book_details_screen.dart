import 'dart:io';

import 'package:beanz_assessment/domain/models/Book.dart';
import 'package:beanz_assessment/presentation/Bloc/book_bloc/book_bloc.dart';
import 'package:beanz_assessment/presentation/Bloc/book_bloc/book_event.dart';
import 'package:beanz_assessment/presentation/Bloc/favorite_bloc/favorite_book_bloc.dart';
import 'package:beanz_assessment/presentation/Bloc/favorite_bloc/favorite_book_event.dart';
import 'package:beanz_assessment/presentation/Bloc/favorite_bloc/favorite_book_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BookDetails extends StatelessWidget {
  final Book book;

  const BookDetails({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteBloc()..add(LoadFavoritesEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(book.title),
          actions: [
            BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, state) {
                bool isFavorite = false;
                if (state is FavoriteLoaded) {
                  isFavorite = state.favorites[book.id] ?? false;
                }

                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    context
                        .read<FavoriteBloc>()
                        .add(ToggleFavoriteEvent(book.id!));
                    // Ensure UI updates immediately
    context.read<FavoriteBloc>().add(LoadFavoritesEvent());

    // Refresh book list to remove it from favorites tab
    context.read<BookBloc>().add(FetchBooksEvent()); 
                  },
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Card(
                  child: Image.file(
                    File(book.image!),
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image,
                          size: 100, color: Colors.red);
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Title: ${book.title}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Author: ${book.author}", style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text(
                  "Published date: ${book.publicationDate==null?" ":DateFormat('yyyy-MM-dd').format(book.publicationDate!)} ",
                  style: TextStyle(fontSize: 18))
            ],
          ),
        ),
      ),
    );
  }
}
