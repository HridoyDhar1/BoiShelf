import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});
static const String name='chat_list';
  String getOtherUserId(List<dynamic> users) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;
    return users.firstWhere((uid) => uid != currentUid);
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('users', arrayContains: currentUid)
            .orderBy('lastTimestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return const Center(child: Text('No chats yet.'));
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final users = List<String>.from(chat['users']);
              final otherUserId = getOtherUserId(users);
              final lastMessage = chat['lastMessage'] ?? '';
              final lastTimestamp = chat['lastTimestamp'] as Timestamp?;

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('Profile').doc(otherUserId).get(),
                builder: (context, userSnapshot) {
                  String otherUserName = "User";
                  if (userSnapshot.hasData && userSnapshot.data!.data() != null) {
                    final userData = userSnapshot.data!.data()! as Map<String, dynamic>;
                    otherUserName = userData['name'] ?? "User";
                  }

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: userSnapshot.hasData && userSnapshot.data!.data() != null && (userSnapshot.data!.data()! as Map<String, dynamic>)['image_url'] != null
                          ? NetworkImage((userSnapshot.data!.data()! as Map<String, dynamic>)['image_url'])
                          : null,
                      child: userSnapshot.connectionState == ConnectionState.waiting || (userSnapshot.data?.data() == null)
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(otherUserName),
                    subtitle: Text(lastMessage),
                    trailing: lastTimestamp != null
                        ? Text(
                      TimeOfDay.fromDateTime(lastTimestamp.toDate()).format(context),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    )
                        : null,
                    onTap: () {
                      // Open chat screen with otherUserId
                      Get.toNamed('/chat_screen', arguments: {
                        'receiverId': otherUserId,
                        'receiverName': otherUserName,
                        'chatId': chat.id,
                      });
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
