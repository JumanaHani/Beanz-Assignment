import 'package:beanz_assessment/data/data_source/remote/book_api_services.dart';
import 'package:beanz_assessment/domain/models/Book.dart';
import 'package:beanz_assessment/presentation/Bloc/bloc/book_event.dart';
import 'package:beanz_assessment/presentation/Bloc/bloc/book_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookApiService _bookApiService;

  BookBloc(this._bookApiService) : super(BooksLoadingState()) {
    on<FetchBooksEvent>(_onFetchBooks);
    on<SearchBooksEvent>(_onSearchBooks);
    on<AddBookEvent>(_onAddBook);
    on<EditBookEvent>(_onEditBook);
    on<DeleteBookEvent>(_onDeleteBook);
  }

  Future<void> _onFetchBooks(FetchBooksEvent event, Emitter<BookState> emit) async {
    emit(BooksLoadingState());
    try {
      final books = await _bookApiService.fetchBooks();
      emit(BooksLoadedState(books: books, filteredBooks: books));
    } catch (e) {
      emit(BooksErrorState(e.toString()));
    }
  }

  Future<void> _onSearchBooks(SearchBooksEvent event, Emitter<BookState> emit) async {
    if (state is BooksLoadedState) {
      final currentState = state as BooksLoadedState;
      final filteredBooks = currentState.books
          .where((book) => book.title.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(BooksLoadedState(books: currentState.books, filteredBooks: filteredBooks));
    }
  }

  Future<void> _onAddBook(AddBookEvent event, Emitter<BookState> emit) async {
    try {
      final newBook = await _bookApiService.addBook(event.book);
      if (state is BooksLoadedState) {
        final currentState = state as BooksLoadedState;
        final updatedBooks = List<Book>.from(currentState.books)..add(newBook);
        emit(BooksLoadedState(books: updatedBooks, filteredBooks: updatedBooks));
      }
    } catch (e) {
      emit(BooksErrorState(e.toString()));
    }
  }

  Future<void> _onEditBook(EditBookEvent event, Emitter<BookState> emit) async {
    try {
      final updatedBook = await _bookApiService.editBook(event.book);
      if (state is BooksLoadedState) {
        final currentState = state as BooksLoadedState;
        final updatedBooks = currentState.books.map((b) => b.id == updatedBook.id ? updatedBook : b).toList();
        emit(BooksLoadedState(books: updatedBooks, filteredBooks: updatedBooks));
      }
    } catch (e) {
      emit(BooksErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteBook(DeleteBookEvent event, Emitter<BookState> emit) async {
    try {
      await _bookApiService.deleteBook(event.bookId.toString());
      if (state is BooksLoadedState) {
        final currentState = state as BooksLoadedState;
        final updatedBooks = currentState.books.where((b) => b.id != event.bookId).toList();
        emit(BooksLoadedState(books: updatedBooks, filteredBooks: updatedBooks));
      }
    } catch (e) {
      emit(BooksErrorState(e.toString()));
    }
  }
}
