import 'dart:io';
import 'package:beanz_assessment/presentation/Bloc/bloc/book_bloc.dart';
import 'package:beanz_assessment/presentation/Bloc/bloc/book_event.dart';
import 'package:beanz_assessment/presentation/Bloc/bloc/book_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BooksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Books')),
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
                      return Container(
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
                          title: Text(book.title),
                          subtitle: Text(book.author),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {}),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  context
                                      .read<BookBloc>()
                                      .add(DeleteBookEvent(book.id.toString()));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is BooksErrorState) {
                  return Center(child: Text(state.error));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
