import 'package:get/get.dart';
import 'package:book/feature/explore/data/model/book_model.dart';

class BookController extends GetxController {
  RxList<Book> books = <Book>[].obs;

  void addBook(Book book) {
    books.insert(0, book);
  }
}
