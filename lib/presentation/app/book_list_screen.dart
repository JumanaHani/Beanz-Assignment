import 'dart:io';
import 'package:flutter/material.dart';
import 'package:beanz_assessment/data/models/Book.dart';
import 'package:beanz_assessment/presentation/app/book_list_controller.dart';

class BooksList extends StatefulWidget {
  const BooksList({super.key});

  @override
  State<BooksList> createState() => _BooksListState();
}

class _BooksListState extends State<BooksList> {
  final BookController _bookController = BookController(); // Controller instance

  @override
  void initState() {
    super.initState();
    _bookController.fetchBooks();  // Fetch books when the widget is initialized
    _bookController.initSearchController();  // Initialize search controller
  }

  @override
  void dispose() {
    _bookController.dispose();  // Clean up resources when the widget is disposed
    super.dispose();
  }

  // Method to show the error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books List'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _bookController.searchController,
              decoration: InputDecoration(
                hintText: 'Search by title or author',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder<List<Book>>(
        valueListenable: _bookController.filteredBooksNotifier,  // Listen for filtered books
        builder: (context, filteredBooks, _) {
          // Check for any error
          return ValueListenableBuilder<String?>(
            valueListenable: _bookController.errorNotifier,
            builder: (context, errorMessage, _) {
              if (errorMessage != null) {
                // If there's an error, show the error dialog
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _showErrorDialog(errorMessage);
                });
              }

              return filteredBooks.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.file(
                            File(filteredBooks[index].image!),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.broken_image, size: 50, color: Colors.grey);
                            },
                          ),
                          title: Text(filteredBooks[index].title),
                          subtitle: Text(filteredBooks[index].author),
                          onTap: () {
                            // Handle tap event
                          },
                        );
                      },
                    );
            },
          );
        },
      ),
    );
  }
}
