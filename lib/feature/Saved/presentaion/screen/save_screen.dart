import 'package:book/feature/home/presentation/widget/bookpost_card.dart';
import 'package:flutter/material.dart';

import '../controller/book_controller.dart';


class SaveScreen extends StatefulWidget {

  const SaveScreen({super.key});
static const String name='/save';
  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  final BookmarkManager bookmarkManager = BookmarkManager();

  @override
  Widget build(BuildContext context) {
    final bookmarkedBooks = bookmarkManager.bookmarkedBooks;

    return Scaffold(
backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Saved Books'),
      ),
      body: bookmarkedBooks.isEmpty
          ? const Center(
        child: Text('No bookmarked books yet'),
      )
          : ListView.builder(
        itemCount: bookmarkedBooks.length,
        itemBuilder: (context, index) {
          final book = bookmarkedBooks[index];
          return BookPostCard(data: book.toJson(), book: book,);
        },
      ),
    );
  }
}
