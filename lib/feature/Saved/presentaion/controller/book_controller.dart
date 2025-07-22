
import '../../../explore/data/model/book_model.dart';

class BookmarkManager {
  BookmarkManager._privateConstructor();

  static final BookmarkManager _instance = BookmarkManager._privateConstructor();

  factory BookmarkManager() {
    return _instance;
  }

  final List<Book> _bookmarkedBooks = [];

  List<Book> get bookmarkedBooks => List.unmodifiable(_bookmarkedBooks);

  void add(Book book) {
    if (!_bookmarkedBooks.contains(book)) {
      _bookmarkedBooks.add(book);
    }
  }

  void remove(Book book) {
    _bookmarkedBooks.remove(book);
  }

  bool isBookmarked(Book book) {
    return _bookmarkedBooks.contains(book);
  }
}
// import '../../../explore/data/model/book_model.dart';
//
// class BookmarkManager {
//   static final List<Book> _bookmarkedBooks = [];
//
//   List<Book> get bookmarkedBooks => _bookmarkedBooks;
//
//   bool isBookmarked(Book book) => _bookmarkedBooks.any((b) => b.id == book.id);
//
//   void add(Book book) {
//     if (!isBookmarked(book)) {
//       _bookmarkedBooks.add(book);
//     }
//   }
//
//   void remove(Book book) {
//     _bookmarkedBooks.removeWhere((b) => b.id == book.id);
//   }
// }
