import 'package:beanz_assessment/data/data_source/remote/book_api_services.dart';
import 'package:beanz_assessment/domain/models/Book.dart';
import 'package:beanz_assessment/presentation/Bloc/book_bloc/book_bloc.dart';
import 'package:beanz_assessment/presentation/Bloc/book_bloc/book_event.dart';
import 'package:beanz_assessment/presentation/Bloc/book_bloc/book_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookApiService extends Mock implements BookApiService {}
class FakeBook extends Fake implements Book {}
void main() {
  group('Book bloc test', () {
    late BookBloc bookBloc;
    late MockBookApiService mockBookApiService;
    late List<Book> mockBooks;
    setUpAll((){
      registerFallbackValue(FakeBook());
    });
    setUp(() {
      mockBookApiService = MockBookApiService();
      bookBloc = BookBloc(mockBookApiService);

      // Sample books
      mockBooks = [
        Book(id: "1", title: "Flutter Basics", author: "John Doe"),
        Book(id: "2", title: "Dart Advanced", author: "Jane Smith"),
      ];
    });
    tearDown(() {
      bookBloc.close();
    });
    test('Initial state should be BooksLoadingState', () {
      expect(bookBloc.state, isA<BooksLoadingState>());
    });

    blocTest<BookBloc, BookState>(
      'emits [BooksLoadedState] when FetchBooksEvent is added',
      build: () {
        when(() => mockBookApiService.fetchBooks())
            .thenAnswer((_) async => mockBooks);
        return bookBloc;
      },
      act: (bloc) => bloc.add(FetchBooksEvent()),
      expect: () => [
        BooksLoadingState(),
        BooksLoadedState(books: mockBooks, filteredBooks: mockBooks),
      ],
    );

    blocTest<BookBloc, BookState>(
      'emits [BooksLoadedState] with filtered books when SearchBooksEvent is added',
      build: () => bookBloc,
      seed: () => BooksLoadedState(books: mockBooks, filteredBooks: mockBooks),
      act: (bloc) => bloc.add(SearchBooksEvent("Flutter")),
      expect: () => [
        BooksLoadedState(
          books: mockBooks,
          filteredBooks: [
            mockBooks.first
          ], // Should return only "Flutter Basics"
        ),
      ],
    );

    blocTest<BookBloc, BookState>(
      'emits [BooksLoadedState] with new book when AddBookEvent is added',
      build: () {
        when(() => mockBookApiService.addBook(any())).thenAnswer(
            (_) async => Book(id: '3', title: "New Book", author: "Author X"));
        return bookBloc;
      },
      seed: () => BooksLoadedState(books: mockBooks, filteredBooks: mockBooks),
      act: (bloc) => bloc.add(
          AddBookEvent(Book(id: '3', title: "New Book", author: "Author X"))),
      expect: () => [
        BooksLoadedState(
          books: [
            ...mockBooks,
            Book(id: '3', title: "New Book", author: "Author X")
          ],
          filteredBooks: [
            ...mockBooks,
            Book(id: '3', title: "New Book", author: "Author X")
          ],
        ),
      ],
    );

    blocTest<BookBloc, BookState>(
      'emits [BooksLoadedState] with updated book when EditBookEvent is added',
      build: () {
        when(() => mockBookApiService.editBook(any())).thenAnswer((_) async =>
            Book(id: '1', title: "Updated Title", author: "John Doe"));
        return bookBloc;
      },
      seed: () => BooksLoadedState(books: mockBooks, filteredBooks: mockBooks),
      act: (bloc) => bloc.add(EditBookEvent(
          Book(id: '1', title: "Updated Title", author: "John Doe"))),
      expect: () => [
        BooksLoadedState(
          books: [
            Book(id: '1', title: "Updated Title", author: "John Doe"),
            mockBooks[1]
          ],
          filteredBooks: [
            Book(id: '1', title: "Updated Title", author: "John Doe"),
            mockBooks[1]
          ],
        ),
      ],
    );

    blocTest<BookBloc, BookState>(
      'emits [BooksLoadedState] with book removed when DeleteBookEvent is added',
      build: () {
        when(() => mockBookApiService.deleteBook("1")).thenAnswer((_) async {});
        return bookBloc;
      },
      seed: () => BooksLoadedState(books: mockBooks, filteredBooks: mockBooks),
      act: (bloc) => bloc.add(DeleteBookEvent('1')),
      expect: () => [
        BooksLoadedState(
          books: [mockBooks[1]], // Only the second book remains
          filteredBooks: [mockBooks[1]],
        ),
      ],
    );
  });
}
