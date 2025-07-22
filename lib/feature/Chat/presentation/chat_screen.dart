import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
static const String name='chat_screen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String receiverId;
  late String receiverName;
  String? chatId;
  late Map<String, dynamic>? postData;
  final currentUid = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    receiverId = args['receiverId'];
    receiverName = args['receiverName'];
    chatId = args['chatId'];
    _initChat();
    postData = args['postData'];
  }

  Future<void> _initChat() async {
    // If chatId is not provided, create/find chat document for these two users
    if (chatId == null) {
      final chatQuery = await FirebaseFirestore.instance
          .collection('chats')
          .where('users', arrayContains: currentUid)
          .get();

      for (var doc in chatQuery.docs) {
        final users = List<String>.from(doc['users']);
        if (users.contains(receiverId)) {
          chatId = doc.id;
          setState(() {});
          return;
        }
      }

      // No chat found, create new
      final newChatDoc = await FirebaseFirestore.instance.collection('chats').add({
        'users': [currentUid, receiverId],
        'lastMessage': '',
        'lastTimestamp': FieldValue.serverTimestamp(),
      });
      chatId = newChatDoc.id;
      setState(() {});
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || chatId == null) return;

    final messagesRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages');

    await messagesRef.add({
      'senderId': currentUid,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Update last message info on chat doc
    await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'lastTimestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (chatId == null) {
      // Waiting for chatId to load
      return Scaffold(
        appBar: AppBar(title: Text(receiverName)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(receiverName)),
      body: Column(
        children: [
          _buildPostPreview(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final docs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final message = docs[index];
                    final isMe = message['senderId'] == currentUid;
                    return Container(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blueAccent : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        child: Text(
                          message['text'],
                          style: TextStyle(color: isMe ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPostPreview() {
    if (postData == null) return const SizedBox.shrink();

    final images = postData!['images'] as List<dynamic>? ?? [];
    final imageUrl = images.isNotEmpty ? images[0] : null;
    final bookName = postData!['book_name'] ?? '';
    final price = postData!['price'] ?? '';
    final condition = postData!['location'] ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: imageUrl != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(imageUrl, width: 50, height: 150, fit: BoxFit.cover),
        )
            : null,
        title: Text(bookName, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Price: ৳$price\nCondition: $condition'),
      ),
    );
  }

}
