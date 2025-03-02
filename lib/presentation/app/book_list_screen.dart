import 'dart:io';
import 'package:beanz_assessment/presentation/Bloc/book_bloc/book_bloc.dart';
import 'package:beanz_assessment/presentation/Bloc/book_bloc/book_event.dart';
import 'package:beanz_assessment/presentation/Bloc/book_bloc/book_state.dart';
import 'package:beanz_assessment/presentation/details/book_details_screen.dart';
import 'package:beanz_assessment/presentation/widgets/book_form.dart';
import 'package:beanz_assessment/presentation/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (context) => ErrorDialog(message: errorMessage),
  );
}

class BooksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Books Shelf')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Books...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                context.read<BookBloc>().add(SearchBooksEvent(query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<BookBloc, BookState>(
              builder: (context, state) {
                if (state is BooksLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is BooksLoadedState) {
                  return ListView.builder(
                    itemCount: state.filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = state.filteredBooks[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetails(book: book),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            leading: Image.file(
                              File(book.image!),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image,
                                    size: 50, color: Colors.grey);
                              },
                            ),
                            title: Text(
                              book.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ' (by ${book.author})',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  book.description ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                    size: 25,
                                  ),
                                  onPressed: () async {
                                    final updatedBook = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BookForm(book: book),
                                      ),
                                    );
                                    if (!context.mounted) return;
                                    if (updatedBook != null) {
                                      context.read<BookBloc>().add(
                                          EditBookEvent(
                                              updatedBook)); // Refresh list
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    context.read<BookBloc>().add(
                                        DeleteBookEvent(book.id.toString()));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is BooksErrorState) {
                  showErrorDialog(context, state.error);
                }
                return Container();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newBook = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookForm()),
          );
          if (!context.mounted) return;
          if (newBook != null) {
            context.read<BookBloc>().add(AddBookEvent(newBook));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
