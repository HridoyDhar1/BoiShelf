
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverImage;
  final Map<String, dynamic> postData;
  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage, required this.postData,
  });
  factory ChatScreen.fromArgs(Map<String, dynamic>? args) {
    args ??= {};
    return ChatScreen(
      receiverId: args['receiverId'] ?? '',
      receiverName: args['receiverName'] ?? 'Unknown',
      receiverImage: args['receiverImage'] ?? '',
      postData: args['postData'] ?? {},
    );
  }

  static const String name='chat_screen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  void sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    FirebaseFirestore.instance.collection('chats').add({
      'senderId': currentUserId,
      'receiverId': widget.receiverId,
      'message': _messageController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.receiverImage)),
            const SizedBox(width: 10),
            Text(widget.receiverName),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildPostPreview(),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final allMessages = snapshot.data!.docs;
                final messages = allMessages.where((doc) {
                  final sender = doc['senderId'];
                  final receiver = doc['receiverId'];
                  return (sender == currentUserId && receiver == widget.receiverId) ||
                      (sender == widget.receiverId && receiver == currentUserId);
                }).toList();

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index];
                    final isMe = data['senderId'] == currentUserId;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[100] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(data['message']),
                      ),
                    );
                  },
                );
              },
            ),

          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget _buildPostPreview() {
    final post = widget.postData;
    final images = post['images'] as List?;

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (images != null && images.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                images[0],
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            post['book_name'] ?? 'Unknown Title',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text("৳ ${post['price']?.toString() ?? '0'}"),
          const SizedBox(height: 4),
          Text("Condition: ${post['condition'] ?? ''}"),
        ],
      ),
    );
  }

}
