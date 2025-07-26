

import 'package:book/core/config/navigation_controller.dart';


import 'package:book/feature/explore/presentation/screen/explore_screen.dart';
import 'package:book/feature/home/presentation/screen/home_screen.dart';
import 'package:book/feature/profile/presentation/screen/profile_screen.dart';
import 'package:book/feature/sell/presentation/screen/sell_book.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomNavigationScreen extends StatelessWidget {
  final NavigationController navigationController = Get.put(
    NavigationController(),
  );
  static const String name = '/navigation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {

        return IndexedStack(
          index: navigationController.selectedIndex.value,
          children: [

            HomeScreen(),
           ExploreScreen(),
            SellBookScreen(),

             // SaveScreen(),
            ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid)
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          currentIndex: navigationController.selectedIndex.value,
          onTap: (index) => navigationController.updateIndex(index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'EXPLORE'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
            // BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'SAVED'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PROFILE'),
          ],
        );
      }),
    );
  }
}
