import 'package:beanz_assessment/domain/models/Book.dart';

abstract class BookEvent {}

class FetchBooksEvent extends BookEvent {}

class SearchBooksEvent extends BookEvent {
  final String query;
  SearchBooksEvent(this.query);
}
class AddBookEvent extends BookEvent {
  final Book book;
  AddBookEvent(this.book);
}

class EditBookEvent extends BookEvent {
  final Book book;
  EditBookEvent(this.book);
}

class DeleteBookEvent extends BookEvent {
  final String bookId;
  DeleteBookEvent(this.bookId);
}