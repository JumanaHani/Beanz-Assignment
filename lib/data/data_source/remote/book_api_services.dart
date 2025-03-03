import 'dart:convert';
import 'dart:io';
import 'package:beanz_assessment/domain/models/Book.dart';
import 'package:http/http.dart' as http;

class BookApiService {
  // Mock API server URLs
  static const String baseUrl =
      "http://192.168.208.185:3001/books"; // For physical devices use the ip address of the mock api server
  // static const String baseUrl = 'http://10.0.2.2:3001/books'; // For Emulator

  // Fetch all books
  Future<List<Book>> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load books: ${response.statusCode}");
      }
    } on SocketException {
      throw Exception("No internet connection. Please check your network.");
    } on FormatException {
      throw Exception("Failed to parse data. Please try again.");
    } catch (e) {
      throw Exception("An unexpected error occurred: ${e.toString()}");
    }
  }

  // Add a new book
  Future<Book> addBook(Book book) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(book.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Book.fromJson(responseData);
      } else {
        throw Exception('Failed to add book: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception("No internet connection.");
    } on FormatException {
      throw Exception("Invalid response format.");
    } catch (e) {
      throw Exception("An error occurred: ${e.toString()}");
    }
  }

  // Edit an existing book
  Future<Book> editBook(Book book) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${book.id}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(book.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Book.fromJson(responseData);
      } else {
        throw Exception('Failed to update book: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception("No internet connection.");
    } on FormatException {
      throw Exception("Invalid response format.");
    } catch (e) {
      throw Exception("An error occurred: ${e.toString()}");
    }
  }

  // Delete a book
  Future<void> deleteBook(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete book: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception("No internet connection.");
    } catch (e) {
      throw Exception("An error occurred: ${e.toString()}");
    }
  }
}
