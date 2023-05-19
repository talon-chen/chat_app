import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late final dynamic user;
  String? messageText;
  final messageTextController = TextEditingController();
  bool isMe = false;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      user = _auth.currentUser;
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _auth.signOut();
                context.go('/');
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong..');
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            // check who is login user
                            user.email == data['sender']
                                ? isMe = true
                                : isMe = false;
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                // where the bubble sits
                                crossAxisAlignment: isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['sender'],
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Material(
                                    borderRadius: isMe
                                        ? const BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            bottomLeft: Radius.circular(30),
                                            bottomRight: Radius.circular(30),
                                          )
                                        : const BorderRadius.only(
                                            topRight: Radius.circular(30),
                                            bottomLeft: Radius.circular(30),
                                            bottomRight: Radius.circular(30),
                                          ),
                                    elevation: 5,
                                    color: isMe
                                        ? Colors.lightBlueAccent
                                        : Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10.0,
                                        horizontal: 20.0,
                                      ),
                                      child: Text(
                                        data['text'],
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: isMe
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                          .toList()
                          .cast(),
                    ),
                  );
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': user.email,
                        'timestamp': Timestamp.now(),
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
