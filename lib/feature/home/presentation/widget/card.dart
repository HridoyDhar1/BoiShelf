// // Book Image
// images.isNotEmpty
// ? ClipRRect(
// borderRadius: BorderRadius.circular(8),
// child: Image.network(
// images[0],
// height: 100,
// width: 80,
// fit: BoxFit.cover,
// ),
// )
//     : Container(
// height: 100,
// width: 80,
// color: Colors.grey[300],
// child: const Icon(Icons.book, size: 40),
// ),
// const SizedBox(width: 12),
// // Book Details
// Expanded(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(data['book_name'] ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
// const SizedBox(height: 6),
// Text("৳ ${data['price']?.toString() ?? '0'}", style: const TextStyle(fontSize: 14, color: Colors.green)),
// const SizedBox(height: 6),
// Text("Condition: ${data['condition'] ?? ''}", style: const TextStyle(fontSize: 13)),
// const SizedBox(height: 6),
// Text("Location: ${data['location'] ?? ''}", style: const TextStyle(fontSize: 13)),
// ],
// ),
