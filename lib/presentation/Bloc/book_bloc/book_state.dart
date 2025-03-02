import 'package:beanz_assessment/domain/models/Book.dart';

abstract class BookState {}

class BooksLoadingState extends BookState {}

class BooksLoadedState extends BookState {
  final List<Book> books;
  final List<Book> filteredBooks;
  BooksLoadedState({required this.books, required this.filteredBooks});
}

class BooksErrorState extends BookState {
  final String error;
  BooksErrorState(this.error);
}
