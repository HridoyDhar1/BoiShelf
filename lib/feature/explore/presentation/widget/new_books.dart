// // ignore_for_file: use_super_parameters
//
//
// import 'package:flutter/material.dart';
//
//
// import '../../../../core/widget/book_details.dart';
// import '../../../../core/widget/book_iteam.dart';
// import '../../data/model/book_model.dart';
//
// class BookSection extends StatelessWidget {
//
//   final List<Book> books;
//
//   const BookSection({
//     Key? key,
//
//     required this.books,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//
//         const SizedBox(height: 8),
//
//         SizedBox(
//           height: 300,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: books.length,
//             itemBuilder: (context, index) {
//               final book = books[index];
//               final List imageUrls=book['images']??[];
//               return BookIteam(
//                 imagePath: book.imageUrls.isNotEmpty?book.imageUrls[0]:'',
//                 title: book.bookName,
//                 // location: book.location,
//                 price: book.price,
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => BookDetailScreen(book: book),
//                     ),
//                   );
//                 }, location: '',
//               );
//
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
