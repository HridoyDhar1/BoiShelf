
import 'package:book/feature/home/presentation/widget/bookpost_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('BookBuy', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed("/chat_list"),
            icon: const Icon(Icons.forum),
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
            const SizedBox(height: 20),
            const Text(
              'All Books',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF001F54),
              ),
            ),
            const SizedBox(height: 10),
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
                    final book=Book.fromMap(data,doc.id);
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
}
