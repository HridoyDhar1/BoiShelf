import 'package:flutter/material.dart';

import '../../feature/explore/data/model/book_model.dart';


class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.bookName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(

          children: [
            // Center(child: Image.asset(book.imageUrls, height: 250,width: 300,)),
            const SizedBox(height: 16),
            Text(book.bookName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Icon(Icons.location_on),
                // Text(book.location),
              ],
            ),

            const SizedBox(height: 20),
            const Text("Description",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
             Text(book.description,textAlign: TextAlign.center),
            const SizedBox(height: 200),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Row(
                children: [
                  const Text("Price :",style: TextStyle(fontSize: 20)),
                  // Text(book.price, style: const TextStyle(fontSize: 20, color: Colors.pink,fontWeight: FontWeight.bold)),
                ],
              ),
              GestureDetector(
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(color: Colors.black87,borderRadius: BorderRadius.circular(10)
                
                  ),child: Center(child: Text("Chat",style: TextStyle(fontSize: 20,color: Colors.white))),
                ),
              )
            ],)
          ],
        ),
      ),
    );
  }
}
