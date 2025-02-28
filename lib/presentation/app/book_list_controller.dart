import 'package:beanz_assessment/data/data_source/remote/book_api_services.dart';
import 'package:beanz_assessment/data/models/Book.dart';
import 'package:flutter/material.dart';


class BookController {
  final BookApiService _bookApiService = BookApiService();
  final TextEditingController searchController = TextEditingController();
  
  // Streams or callbacks to update the UI
  ValueNotifier<List<Book>> booksNotifier = ValueNotifier([]);
  ValueNotifier<List<Book>> filteredBooksNotifier = ValueNotifier([]);
  final ValueNotifier<String?> errorNotifier = ValueNotifier<String?>(null);
  // Fetch books from API
  // Fetch books and handle errors
  Future<void> fetchBooks() async {
  try {
    List<Book> books = await _bookApiService.fetchBooks();
    booksNotifier.value = books; // Store the original list
    filteredBooksNotifier.value = books; // Initialize filtered list
  } catch (e) {
    errorNotifier.value = e.toString(); // Pass the error message to the UI
  }
}

  // Filter books based on search query
  void filterBooks(String query) {
    final List<Book> books = booksNotifier.value;
    if (query.isEmpty) {
      filteredBooksNotifier.value = books; // Show all books if query is empty
    } else {
      filteredBooksNotifier.value = books.where((book) {
        //filter books based on title or author name
        return book.title.toLowerCase().contains(query.toLowerCase()) ||
            book.author.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  // Add listener to search controller to trigger filtering
  void initSearchController() {
    searchController.addListener(() {
      filterBooks(searchController.text);  // Filter books as the user types
    });
  }

  // Dispose controller and stream
  void dispose() {
    searchController.dispose();
    booksNotifier.dispose();
    filteredBooksNotifier.dispose();
  }
}
