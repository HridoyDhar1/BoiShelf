// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class ChatListScreen extends StatelessWidget {
//   const ChatListScreen({super.key});
// static const String name='chat_list';
//   String getOtherUserId(List<dynamic> users) {
//     final currentUid = FirebaseAuth.instance.currentUser!.uid;
//     return users.firstWhere((uid) => uid != currentUid);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final currentUid = FirebaseAuth.instance.currentUser!.uid;
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chats')),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('chats')
//             .where('users', arrayContains: currentUid)
//             .orderBy('lastTimestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final chats = snapshot.data!.docs;
//
//           if (chats.isEmpty) {
//             return const Center(child: Text('No chats yet.'));
//           }
//
//           return ListView.builder(
//             itemCount: chats.length,
//             itemBuilder: (context, index) {
//               final chat = chats[index];
//               final users = List<String>.from(chat['users']);
//               final otherUserId = getOtherUserId(users);
//               final lastMessage = chat['lastMessage'] ?? '';
//               final lastTimestamp = chat['lastTimestamp'] as Timestamp?;
//
//               return FutureBuilder<DocumentSnapshot>(
//                 future: FirebaseFirestore.instance.collection('Profile').doc(otherUserId).get(),
//                 builder: (context, userSnapshot) {
//                   String otherUserName = "User";
//                   if (userSnapshot.hasData && userSnapshot.data!.data() != null) {
//                     final userData = userSnapshot.data!.data()! as Map<String, dynamic>;
//                     otherUserName = userData['name'] ?? "User";
//                   }
//
//                   return ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: userSnapshot.hasData && userSnapshot.data!.data() != null && (userSnapshot.data!.data()! as Map<String, dynamic>)['image_url'] != null
//                           ? NetworkImage((userSnapshot.data!.data()! as Map<String, dynamic>)['image_url'])
//                           : null,

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});
static const String name='chat_list';
  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final chats = snapshot.data!.docs;
          final Map<String, Map<String, dynamic>> recentChats = {};

          for (var chat in chats) {
            final senderId = chat['senderId'];
            final receiverId = chat['receiverId'];
            final chatPartnerId = senderId == currentUserId ? receiverId : senderId;

            if (!recentChats.containsKey(chatPartnerId)) {
              recentChats[chatPartnerId] = {
                'lastMessage': chat['message'],
                'timestamp': chat['timestamp'],
              };
            }
          }

          return ListView(
            children: recentChats.entries.map((entry) {
              final userId = entry.key;
              final message = entry.value['lastMessage'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('Profile').doc(userId).get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();

                  final userData = snapshot.data!.data() as Map<String, dynamic>?;

                  if (userData == null) return const SizedBox();

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(userData['image_url'] ?? ""),
                    ),
                    title: Text(userData['name'] ?? 'User'),
                    subtitle: Text(message ?? ''),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            receiverId: userId,
                            receiverName: userData['name'] ?? '',
                            receiverImage: userData['image_url'] ?? '', postData: userData['postData'
                          ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
