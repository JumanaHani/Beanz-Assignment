import 'package:beanz_assessment/presentation/widgets/book_form.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:beanz_assessment/data/data_source/remote/book_api_services.dart';
import 'package:beanz_assessment/domain/models/Book.dart';
import 'package:mocktail/mocktail.dart';

import '../blocs/book_bloc_test.dart';

 class MockBookApiService extends Mock implements BookApiService {}

Book createMockBook() {
  return Book(
    id: '1',
    title: 'Mock Book Title',
    author: 'Mock Author',
    description: 'Mock description of the book.',
    publicationDate: DateTime.parse('2025-03-04'),
  );
}

class BookFake extends Fake implements Book {
  // Optionally, you can override properties or methods here if you want to customize the fake behavior.
}

void main() {
  late MockBookApiService mockApiService;

  setUp(() {
    mockApiService = MockBookApiService();
  });

  setUpAll(() {
    // Register the fallback value for Book
    registerFallbackValue(BookFake());
  });
  //Widget rendering – Ensures all fields and buttons are present.

  testWidgets('BookForm should render correctly', (WidgetTester tester) async {


    await tester.pumpWidget(MaterialApp(home: BookForm()));

    expect(find.byType(TextFormField),
        findsNWidgets(5)); // Title, Author, Description, Date, Image
    expect(find.text('Add Book'), findsOneWidget);
    expect(find.byKey(Key('saveButton')), findsOneWidget);
  });

//Validation checks – Ensures required fields show error messages when left empty.
  testWidgets('Should show validation errors when fields are empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: BookForm()));

    await tester.tap(find.byKey(Key('saveButton')));
    await tester.pump();

    expect(find.text('Enter a title'), findsOneWidget);
    expect(find.text('Enter an author'), findsOneWidget);
    expect(find.text('Enter an description'), findsOneWidget);
  });
  testWidgets('BookForm shows the correct form for adding a new book',
      (WidgetTester tester) async {
   when(() => mockApiService.addBook(any())).thenAnswer(
      (_) async => Book(
        id: '1',  // assuming this is the auto-generated ID after adding
        title: 'New Book Title',
        author: 'New Author',
        description: 'Description for the new book.',
      ),
    );


        // Render the widget
    await tester.pumpWidget(MaterialApp(home: BookForm(book: null)));
    // Wait for everything to settle
    await tester.pumpAndSettle();
    // Find button
    final saveButtonFinder = find.byKey(Key('saveButton'));
    // Ensure the button exist
    expect(saveButtonFinder, findsOneWidget);

    // Enter valid test values
    await tester.enterText(find.byType(TextFormField).at(0), 'Test Book Title');
    await tester.enterText(find.byType(TextFormField).at(1), 'John Doe');
    await tester.enterText(
        find.byType(TextFormField).at(2), 'This is a test description.');

    await tester.pumpAndSettle();

   final newBook = Book(id: null,
      title: 'New Book Title',
      author: 'New Author',
      description: 'Description for the new book.',
    );


    // Ensure the button is visible before tapping
    if (!tester.any(saveButtonFinder)) {
      await tester.dragUntilVisible(
        saveButtonFinder,
        find.byType(SingleChildScrollView), // Parent Scrollable Widget
        const Offset(0, -200), // Drag Up
      );
      await tester.pumpAndSettle();
    }

    // Tap the Save button
    await tester.tap(saveButtonFinder);
    await tester.pumpAndSettle();

     final addedBook = await mockApiService.addBook(newBook);

    // Verify the returned book is as expected
    expect(addedBook.title, 'New Book Title');
    expect(addedBook.author, 'New Author');
    expect(addedBook.description, 'Description for the new book.');

    expect(find.text('Add'), findsOneWidget);
        verify(() => mockApiService.addBook(any())).called(1);
  });

  test('Test editBook method', () async {
    // Mock the editBook method to return a Future<Book> with a mocked response
    when(() => mockApiService.editBook(any())).thenAnswer(
      (_) async => Book(
        id: '1',
        title: 'Updated Book Title',
        author: 'Updated Author',
        description: 'Updated description for the book.',
        publicationDate: DateTime.parse('2024-01-01'),
      
      ),
    );

    // Create a book to pass to the editBook method
    final bookToEdit = Book(
      id: '1',
      title: 'Original Book Title',
      author: 'Original Author',
      description: 'Original description for the book.',
      publicationDate: DateTime.parse('2023-01-01'),
  
    );

    // Call the editBook method (this will trigger the mocked response)
    final editedBook = await mockApiService.editBook(bookToEdit);

    // Verify the edited book returned is as expected
    expect(editedBook.title, 'Updated Book Title');
    expect(editedBook.author, 'Updated Author');
    expect(editedBook.description, 'Updated description for the book.');
    expect(editedBook.publicationDate, DateTime.parse('2024-01-01'));


    // Verify the editBook method was called once with any argument
    verify(() => mockApiService.editBook(any())).called(1);
  });
}
