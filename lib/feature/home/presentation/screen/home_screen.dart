import 'package:book/feature/home/presentation/widget/bookpost_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../explore/data/model/book_model.dart';
import '../../data/model/seller_model.dart';
import '../widget/top_seller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String name = '/home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SellerModel> topSellers = [
    SellerModel(name: 'Oliver', avatarPath: 'assets/image/Ellipse 1502.png'),
    SellerModel(name: 'Thomas', avatarPath: 'assets/image/Ellipse 1504.png'),
    SellerModel(name: 'Kyle', avatarPath: 'assets/image/Ellipse 1507.png'),
    SellerModel(name: 'Reece', avatarPath: 'assets/image/Ellipse 1508.png'),
    SellerModel(name: 'Jacob', avatarPath: 'assets/image/Ellipse 1509.png'),
    SellerModel(name: 'Charlie', avatarPath: 'assets/image/Ellipse 1507.png'),
  ];

  final currentUid = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = true;
  String profileImage = "";
  String profileName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'BookBuy',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .where('users', arrayContains: currentUid)
                .snapshots(),
            builder: (context, chatSnapshot) {
              if (!chatSnapshot.hasData) {
                return IconButton(
                  icon: const Icon(Icons.forum),
                  onPressed: () => Get.toNamed('/chat_list'),
                );
              }

              final chatDocs = chatSnapshot.data!.docs;
              return FutureBuilder<int>(
                future: _getUnreadMessageCount(chatDocs),
                builder: (context, snapshot) {
                  final unreadCount = snapshot.data ?? 0;
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.forum),
                        onPressed: () => Get.toNamed('/chat_list'),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 10),
            const Text(
              'Top Seller',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001F54),
              ),
            ),
            const SizedBox(height: 10),

            TopSeller(sellers: topSellers),
            const SizedBox(height: 30),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('books')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Text('Error loading books');
                if (!snapshot.hasData) return const CircularProgressIndicator();

                final books = snapshot.data!.docs;

                return Column(
                  children: books.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final book = Book.fromMap(data, doc.id);
                    return BookPostCard(data: data, book: book);
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to count unread messages from all chats
  Future<int> _getUnreadMessageCount(
    List<QueryDocumentSnapshot> chatDocs,
  ) async {
    int totalUnread = 0;

    for (var chat in chatDocs) {
      final chatId = chat.id;

      final unreadMessages = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .where('senderId', isNotEqualTo: currentUid)
          .get();

      totalUnread += unreadMessages.docs.length;
    }

    return totalUnread;
  }
}
