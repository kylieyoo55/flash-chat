import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String routeId = '/chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final msgTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _snapShot = FirebaseFirestore.instance.collection("msgs").snapshots();

  String msgText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

//before loading screen we pull out loggedin User
  void getCurrentUser() {
    final user = _auth.currentUser;

    try {
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  //getting data from firestore
  // void getMsgs() async {
  //   final msgs = await _fireStore.collection("msgs").get();
  //   for (var m in msgs.docs) {
  //     print(m.data().cast());
  //   }
  // }

  void getMsgStream() async {
    await for (var s in _snapShot) {
      for (var m in s.docs) {
        print(m.data().cast());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //getMsgStream();
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MsgStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: msgTextController,
                      onChanged: (value) {
                        msgText = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      msgTextController.clear();
                      _fireStore.collection("msgs").add({
                        "text": msgText,
                        "sender": loggedInUser.email,
                      });
                    },
                    child: Text(
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

class MsgStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection("msgs").snapshots(),
      builder: (context, snapshot) {
        List<MsgBubble> messageWidgets = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlue,
            ),
          );
        }
        final msg = snapshot.data.docs.reversed;

        for (var m in msg) {
          final msgText = m.data()['text'];
          final msgSender = m.data()['sender'];

          final currentUser = loggedInUser.email;

          final msgWidget =
              MsgBubble(msgText, msgSender, currentUser == msgSender);
          messageWidgets.add(msgWidget);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MsgBubble extends StatelessWidget {
  final String msgText;
  final String msgSender;
  final bool sameSender;

  MsgBubble(this.msgText, this.msgSender, this.sameSender);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
          crossAxisAlignment:
              sameSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              msgSender,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            Material(
              borderRadius: sameSender
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
              elevation: 5,
              color: sameSender ? Colors.lightBlue : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Text(
                  "$msgText ",
                  style: TextStyle(
                    fontSize: 15,
                    color: sameSender ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}
