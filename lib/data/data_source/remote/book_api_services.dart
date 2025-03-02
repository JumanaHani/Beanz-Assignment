import 'dart:convert';
import 'dart:io';
import 'package:beanz_assessment/domain/models/Book.dart';
import 'package:http/http.dart' as http;

class BookApiService {
  // you need to run json-server --watch db.json --port 3001 to generate a mock api server
  static const String baseUrl =
      "http://192.168.166.185:3001/books"; // for physical devices I use the IPadress of the  mock API server device
  //static const String baseUrl = 'http://10.0.2.2:3001/books'; // For Emulator

  Future<List<Book>> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load books: ${response.statusCode}");
      }
    } on SocketException catch (_) {
      throw Exception("No internet connection. Please check your network.");
    } on FormatException catch (_) {
      throw Exception("Failed to parse data. Please try again.");
    } catch (e) {
      throw Exception("An unexpected error occurred. Please try again.");
    }
  }

  // Add a new book
  Future<Book> addBook(Book book) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(book.toJson()),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return Book.fromJson(responseData); // Convert response to Book object
    } else {
      throw Exception('Failed to add book');
    }
  }

  // Edit an existing book
  Future<Book> editBook(Book book) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${book.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(book.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return Book.fromJson(responseData); // Convert response to Book object
    } else {
      throw Exception('Failed to update book');
    }
  }

  // Delete a book
  Future<void> deleteBook(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete book');
    }
  }
}
