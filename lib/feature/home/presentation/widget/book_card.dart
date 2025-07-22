import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Saved/presentaion/controller/book_controller.dart';
import '../../../explore/data/model/book_model.dart';

class BookCard extends StatefulWidget {
  final Book book;
  final Map<String, dynamic> data;
  const BookCard({super.key, required this.book, required this.data});

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool isLoved = false;
  bool isSaved = false;
  bool isMap = false;
  final BookmarkManager bookmarkManager = BookmarkManager();


  late PageController _pagecontroller;
  int _currentPage=0;
  @override
  void initState() {
    super.initState();
    isLoved = false;
    isSaved = bookmarkManager.isBookmarked(widget.book);

  }


  void toggleBookmark() {
    setState(() {
      if (isSaved) {
        bookmarkManager.remove(widget.book);
      } else {
        bookmarkManager.add(widget.book);
      }
      isSaved = !isSaved;
    });

    Get.toNamed("/save");
  }

  @override
  Widget build(BuildContext context) {
    final List images = widget.data['images'] ?? [];

    return Card(
      color: const Color(0xffF7FAFF),
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Uncomment this if you have a profile image
                // const CircleAvatar(
                //   radius: 18,
                //   backgroundImage:
                //   AssetImage('assets/image/user_placeholder.png'),
                // ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.bookName.isNotEmpty
                            ? widget.book.bookName
                            : 'Untitled Book',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                      Text(
                        widget.book.category,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Book Image
          if (images.isNotEmpty)
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 1.3, // portrait ratio
                  child: PageView.builder(
                    itemCount: images.length,
                    onPageChanged: (index){
                      setState(() {
                        _currentPage=index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(images.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _currentPage == index ? 10 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Colors.blueAccent
                            : Colors.grey[400],
                      ),
                    );
                  }),
                ),
              ],
            )



          else
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(Icons.image, size: 60),
            ),
          // Bottom Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('৳ ${widget.book.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('Condition: ${widget.book.condition}',
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 6),
                Text(
                  widget.book.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),

          // Buttons Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 28,
                  icon: Icon(
                    isLoved ? Icons.favorite : Icons.favorite_border,
                    color: isLoved ? Colors.red : Colors.grey[600],
                  ),
                  onPressed: () {
                    setState(() {
                      isLoved = !isLoved;
                    });
                  },
                ),
                IconButton(
                  iconSize: 28,
                  icon: Row(
                    children: [
                      Icon(
                        isMap ? Icons.location_city : Icons.location_on,
                        color: isMap ? Colors.red : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      const Text("4.5KM"),
                    ],
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Map button pressed')),
                    );
                  },
                ),
                IconButton(
                  iconSize: 28,
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? Colors.blue : Colors.grey[600],
                  ),
                  onPressed: toggleBookmark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
