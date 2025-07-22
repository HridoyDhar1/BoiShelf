import 'package:flutter/material.dart';
import '../../data/model/seller_model.dart'; // adjust path as needed

class TopSeller extends StatelessWidget {
  final List<SellerModel> sellers;

  const TopSeller({super.key, required this.sellers});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sellers.length,
        itemBuilder: (context, index) {
          final seller = sellers[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage(seller.avatarPath),
                ),
                const SizedBox(height: 4),
                Text(
                  seller.name,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
