import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

//add buil_runner depandancy in pubspec.yaml
//use this command "flutter pub run build_runner build" to generate the TypeAdapter for Book class
part 'Book.g.dart';

@JsonSerializable() //to automatically generate code for serializing and deserializing Dart objects to and from JSON
@HiveType(typeId: 0)
class Book {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String author;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final String? image;

  @HiveField(5)
  bool isFavorite; // Add the favorite field

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.description,
    this.image,
    this.isFavorite = false,
  });

  // Factory method for json_serializable
  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  // // Method to convert Book to JSON
  Map<String, dynamic> toJson() => _$BookToJson(this);
}
