import 'package:book/feature/home/presentation/widget/map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


import '../../../Chat/presentation/chat_screen.dart';
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
  double? distanceInKm;
  String profileImage = "";
  String profileName = "";

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


  @override
  void initState() {
    super.initState();
    isLoved = false;
    postOwnerUid = widget.data['uid'] ?? '';
    isSaved = BookmarkManager().isBookmarked(widget.book);
    _pagecontroller = PageController();
    loadProfileData();
    calculateDistanceToPost();
  }
  Future<void> calculateDistanceToPost() async {
    try {
      final currentPosition = await getCurrentLocation();
      double? postLat = widget.data['latitude'];
      double? postLng = widget.data['longitude'];

      if (postLat != null && postLng != null) {
        double distanceInMeters = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          postLat,
          postLng,
        );

        setState(() {
          distanceInKm = double.parse((distanceInMeters / 1000).toStringAsFixed(2));
        });
      }
    } catch (e) {
      debugPrint("Distance calculation error: $e");
    }
  }


  Future<void> loadProfileData() async {
    final uid = widget.data['uid'];
    final doc = await FirebaseFirestore.instance.collection('Profile').doc(uid).get();
    final data = doc.data();
    if (data != null) {
      profileName = data['name'] ?? "User";
      profileImage = data['image_url'] ?? "";
    }
    setState(() => isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    final List images = widget.data['images'] ?? [];

    return Card(
      color: Colors.white,

      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(15),),
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


                    onPressed: () {
                      final currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser == null) return;

                      final receiverId = widget.data['uid'];
                      final receiverName = profileName;
                      final receiverImage = profileImage;

                      if (receiverId != currentUser.uid) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ChatScreen(
                                  receiverId: receiverId,
                                  receiverName: receiverName,
                                  receiverImage: receiverImage,
                                  postData:widget.data
                                ),
                          ),
                        );
                      }
                    }),
                Row(
                  children: [
                    Icon(
                      isMap ? Icons.location_city : Icons.location_on,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 6),
                    if (distanceInKm != null)
                      Text(
                        "$distanceInKm km",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      )
                    else
                      const Text(
                        "Calculating...",
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
