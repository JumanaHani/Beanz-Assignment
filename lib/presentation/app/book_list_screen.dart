import 'dart:io';
import 'package:beanz_assessment/domain/models/Book.dart';
import 'package:beanz_assessment/presentation/Bloc/book_bloc/book_bloc.dart';
import 'package:beanz_assessment/presentation/Bloc/book_bloc/book_event.dart';
import 'package:beanz_assessment/presentation/Bloc/book_bloc/book_state.dart';
import 'package:beanz_assessment/presentation/Bloc/favorite_bloc/favorite_book_bloc.dart';
import 'package:beanz_assessment/presentation/Bloc/favorite_bloc/favorite_book_event.dart';
import 'package:beanz_assessment/presentation/Bloc/favorite_bloc/favorite_book_state.dart';
import 'package:beanz_assessment/presentation/details/book_details_screen.dart';
import 'package:beanz_assessment/presentation/widgets/book_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BooksList extends StatefulWidget {
  @override
  _BooksListState createState() => _BooksListState();
}

class _BooksListState extends State<BooksList> {
  @override
  void initState() {
    super.initState();
    // Load books and favorites when the screen opens
    context.read<BookBloc>().add(FetchBooksEvent());
    context.read<FavoriteBloc>().add(LoadFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: All Books & Favorites
      child: Scaffold(
        appBar: AppBar(
          title: Text('Books Shelf'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.library_books), text: 'All Books'),
              Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBooksTab(), // All Books Tab
            _buildFavoritesTab(), // Favorites Tab
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  // Tab 1: All Books List
  Widget _buildBooksTab() {
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state) {
        if (state is BooksLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is BooksLoadedState) {
          return _buildBookList(state.filteredBooks);
        } else if (state is BooksErrorState) {
          return Center(child: Text('Error loading books'));
        }
        return Container();
      },
    );
  }

  // Tab 2: Favorite Books List
  Widget _buildFavoritesTab() {
    return BlocListener<FavoriteBloc, FavoriteState>(
      listener: (context, state) {},
      child: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          context.read<FavoriteBloc>().add(LoadFavoritesEvent());

          if (state is FavoriteLoaded) {
            List<String> favoriteIds = state.favorites.keys
                .where((bookId) => state.favorites[bookId] == true)
                .toList();

            return BlocBuilder<BookBloc, BookState>(
              builder: (context, bookState) {
                if (bookState is BooksLoadedState) {
                  final favoriteBooks = bookState.books
                      .where((book) => favoriteIds.contains(book.id.toString()))
                      .toList();
                  return _buildBookList(favoriteBooks);
                }
                return Center(child: CircularProgressIndicator());
              },
            );
          }
          return Center(child: Text("No Favorites"));
        },
      ),
    );
  }

  // Reusable Widget for Book List
  Widget _buildBookList(List<Book> books) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return _buildBookItem(book);
      },
    );
  }

  // Single Book Item
  Widget _buildBookItem(Book book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookDetails(book: book)),
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
              return Icon(Icons.broken_image, size: 50, color: Colors.grey);
            },
          ),
          title: Text(
            book.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('by ${book.author}', maxLines: 1),
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
                      builder: (context) => BookForm(book: book),
                    ),
                  );
                  if (!context.mounted) return;
                  if (updatedBook != null) {
                    context
                        .read<BookBloc>()
                        .add(EditBookEvent(updatedBook)); // Refresh list
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
                  context
                      .read<BookBloc>()
                      .add(DeleteBookEvent(book.id.toString()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
