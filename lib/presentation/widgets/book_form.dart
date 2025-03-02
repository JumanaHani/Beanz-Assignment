import 'package:beanz_assessment/data/data_source/remote/book_api_services.dart';
import 'package:beanz_assessment/domain/models/Book.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BookForm extends StatefulWidget {
  final Book? book; // If null, it's a new book; otherwise, it's for editing

  const BookForm({super.key, this.book});

  @override
  State<BookForm> createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  final _formKey = GlobalKey<FormState>();
  final BookApiService apiService = BookApiService();

  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController publisedDate;
  late TextEditingController imageController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.book?.title ?? '');
    authorController = TextEditingController(text: widget.book?.author ?? '');
    publisedDate=TextEditingController(text: widget.book?.publicationDate?.toIso8601String() ?? '');
    imageController = TextEditingController(text: widget.book?.image ?? '');
  }

  void saveBook() async {
    if (_formKey.currentState!.validate()) {
      final book = Book(
        id: widget.book?.id,
        title: titleController.text,
        author: authorController.text,
        image: imageController.text,
      );

      try {
        if (widget.book == null) {
          await apiService.addBook(book);
        } else {
          await apiService.editBook(book);
        }
        Navigator.pop(context, book); // Return the new/updated book
      } catch (e) {
        print("Error saving book: $e");
      }
    }
  }

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imageController.text = image.path; // Store the image path
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.book == null ? 'Add Book' : 'Edit Book')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: authorController,
                decoration: InputDecoration(labelText: 'Author'),
                validator: (value) => value!.isEmpty ? 'Enter an author' : null,
              ),
                 SizedBox(height: 20,),
              TextFormField(
                controller: imageController,
                readOnly: true, // Prevent manual input
                onTap: pickImage, // Open gallery on tap
                decoration: InputDecoration(
                  labelText: 'Choose Image',
                  suffixIcon: Icon(Icons.image),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveBook,
                child: Text(widget.book == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
