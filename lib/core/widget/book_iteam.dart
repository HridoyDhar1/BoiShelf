// import 'package:flutter/material.dart';
//
// class BookIteam extends StatelessWidget {
//   final String imagePath;
//   final String title;
//   final double price;
//   final String location;
//   final VoidCallback onTap;
//
//   const BookIteam({
//     Key? key,
//     required this.imagePath,
//     required this.title,
//     required this.price,
//     required this.location,
//     required this.onTap,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 160,
//         margin: const EdgeInsets.symmetric(horizontal: 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image
//              imagePath.isNotEmpty
//                 ? Image.network(
//               imagePath,
//               height: 180,
//               width: 160,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => Container(
//                 height: 180,
//                 width: 160,
//                 color: Colors.grey[300],
//                 child: const Icon(Icons.broken_image),
//               ),
//             )
//                 : Container(
//               height: 180,
//               width: 160,
//               color: Colors.grey[300],
//               child: const Icon(Icons.image, size: 50),
//             ),
//
//             const SizedBox(height: 8),
//             // Title
//             Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 4),
//             // Price
//             Text('৳ $price', style: const TextStyle(color: Colors.green)),
//             const SizedBox(height: 2),
//             // Location
//             Text(location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//           ],
//         ),
//       ),
//     );
//   }
// }
