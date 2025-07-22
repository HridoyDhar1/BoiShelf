import 'package:book/feature/home/presentation/widget/map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../Saved/presentaion/controller/book_controller.dart';
import '../../../explore/data/model/book_model.dart';

class BookPostCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final Book book;

  const BookPostCard({super.key, required this.data, required this.book});

  @override
  State<BookPostCard> createState() => _BookPostCardState();
}

class _BookPostCardState extends State<BookPostCard> {
  bool isLoved = false;
  bool isSaved = false;
  bool isMap = false;
  late final String postOwnerUid;

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _openMap(BuildContext context) async {
    try {
      final position = await getCurrentLocation();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MapScreen(position: position),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  final TextEditingController _nameController = TextEditingController();
  final BookmarkManager bookmarkManager = BookmarkManager();
  late PageController _pagecontroller;
  int _currentPage = 0;
  bool isLoading = true;
  String profileImage = "";

  @override
  void initState() {
    super.initState();
    isLoved = false;
    postOwnerUid = widget.data['uid'] ?? '';
    isSaved = BookmarkManager().isBookmarked(widget.book);
    _pagecontroller = PageController();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    if (postOwnerUid.isEmpty) {
      debugPrint("No post owner UID found.");
      setState(() => isLoading = false);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance.collection('Profile').doc(postOwnerUid).get();
      final data = doc.data();
      if (data != null) {
        _nameController.text = data['name'] ?? "";
        profileImage = data['image_url'] ?? "";
      } else {
        debugPrint("No profile data found for UID: $postOwnerUid");
      }
    } catch (e) {
      debugPrint("Error loading profile data: $e");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final List images = widget.data['images'] ?? [];

    return Card(
      color: const Color(0xffF7FAFF),
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: (!isLoading && profileImage.isNotEmpty)
                      ? NetworkImage(profileImage)
                      : null,
                  child: (isLoading || profileImage.isEmpty)
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.data['book_name'] ?? ''}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "${widget.data['category'] ?? ''}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Images
          if (images.isNotEmpty)
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 1.3,
                  child: PageView.builder(
                    itemCount: images.length,
                    controller: _pagecontroller,
                    onPageChanged: (index) => setState(() => _currentPage = index),
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
                        color: _currentPage == index ? Colors.blueAccent : Colors.grey[400],
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

          const SizedBox(height: 10),

          // Book Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '৳ ${widget.data['price']?.toString() ?? '0'}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Condition: ${widget.data['condition'] ?? ''}',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 28,
                  icon: Icon(
                    isLoved?Icons.favorite:Icons.favorite_border,
                    color: isLoved ? Colors.red : Colors.grey[600],
                  ),
                  // onPressed: () {
                  //   final currentUid = FirebaseAuth.instance.currentUser?.uid;
                  //
                  //   if (currentUid == postOwnerUid) {
                  //     // Optional: Show message or do nothing
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       const SnackBar(content: Text("You can't chat with yourself.")),
                  //     );
                  //     return;
                  //   }
                  //   setState(() {
                  //
                  //     isLoved=!isLoved;
                  //   });
                  //
                  // if(isLoved){
                  //   Get.toNamed("/chat_screen", arguments: {
                  //     "receiverId": postOwnerUid,
                  //     "receiverName": _nameController.text.isNotEmpty
                  //         ? _nameController.text
                  //         : "User",
                  //   });
                  // }
                  // },
                    onPressed: () async {
                      final currentUid = FirebaseAuth.instance.currentUser?.uid;

                      if (currentUid == postOwnerUid) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("You can't chat with yourself.")),
                        );
                        return;
                      }

                      setState(() {
                        isLoved = !isLoved;
                      });

                      if (isLoved) {
                        // Navigate to chat screen and wait until it is popped
                        final result = await Get.toNamed("/chat_screen", arguments: {
                          "receiverId": postOwnerUid,
                          "receiverName": _nameController.text.isNotEmpty
                              ? _nameController.text
                              : "User",
                          "postData": widget.data,
                        });

                        // When returning from chat screen, reload chat list or update UI
                        if (result == true) {
                          // For example, you can notify a chat controller to refresh
                          // Or setState here to refresh data
                          // e.g., chatController.loadChats();
                          debugPrint("Returned from chat screen, refresh chat list");
                          setState(() {});
                        }
                      }
                    }

                ),
                Icon(
                  isMap ? Icons.location_city : Icons.location_on,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
