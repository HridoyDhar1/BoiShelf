
class Book {
  final String id;
  final String bookName;
  final String location;
  final double price;
  final String description;
  final List<String> imageUrls;
  final String condition;
  final String category;

  Book( {
    required this.id,
    required this.bookName,
    required this.location,
    required this.price,
    required this.description,
    required this.imageUrls,
  required  this.condition,
 required   this.category,
  });

  // Convert to Map for Supabase insertion
  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'book_name': bookName,
      'location': location,
      'price': price,
      'description': description,
      'image_urls': imageUrls,
      'condition': condition,
      'category': category,

    };
  }

  // Create a Book from Supabase row
  factory Book.fromMap(Map<String, dynamic> data,String docId) {
    return Book(
      bookName: data['book_name'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      condition: data['condition'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      imageUrls: List<String>.from(data['image_urls'] ?? []), id: docId, location: data['location'],
    );
  }


}
