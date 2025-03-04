import 'package:beanz_assessment/domain/models/Book.dart';
import 'package:equatable/equatable.dart';

abstract class BookState extends Equatable {
  @override
  List<Object?> get props => [];
}
class BooksLoadingState extends BookState {
}

class BooksLoadedState extends BookState {
  final List<Book> books;
  final List<Book> filteredBooks;
  BooksLoadedState( {required this.books, required this.filteredBooks}){print('loaded state');}
   @override
  List<Object?> get props => [books, filteredBooks];
}

class BooksErrorState extends BookState {
  final String error;
  BooksErrorState(this.error);
}
