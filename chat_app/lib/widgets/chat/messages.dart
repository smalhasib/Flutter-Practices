import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final data = snapshot.data?.docs;
        return ListView.builder(
          reverse: true,
          itemBuilder: (context, index) => MessageBubble(
            key: ValueKey(data?[index].id),
            message: data?[index]['text'],
            username: data?[index]['username'],
            image: data?[index]['userImage'],
            isMe: data?[index]['userId'] ==
                FirebaseAuth.instance.currentUser?.uid,
          ),
          itemCount: data?.length,
        );
      },
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
    );
  }
}
