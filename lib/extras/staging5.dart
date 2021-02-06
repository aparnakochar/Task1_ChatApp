import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'registration_screen.dart';
// import 'package:flash_chat/screens/registration_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  // FirebaseFirestore ye dekho break line aa rhi hai?hnto ye depriciated hai okok means?kch pnga h ye purani keyword hai okok hm to  bsyethanhi
  // to phle isko fix karo yeha se tumko kese pata chlega ki kya change karnokok
  // ignore: deprecated_member_use
  // FirebaseUser loggedInUser;
  User loggedInUser;
  String messageText;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser);
      }
    } catch (e) {
      Exception(e);
    }
  }

  // void getMessage() async {
  //   final messages = await _firestore.collection('messages').getDocuments();
  //   for (var message in messages.documents) {
  //     print(message.data());
  //   }
  // } phir chec k kiya ki ye function se msg aa rhe hai ki nhi okarethe to isse pta chala ki ye sahi kaam kar raha hai okok
  void messageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
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
                messageStream();
                //Implement logout functionality
                // _auth.signOut();
                // Navigator.pop(context);
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
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .snapshots(), // to fir yeha bhi sahi hi kaam kar raha hai okhn
              // ignore: missing_return
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                // ignore: deprecated_member_use
                final messages = snapshot.data.docs;

                // ignore: unused_local_variable
                List<MessageBubble> messageBubbles = [];
                for (var message in messages) {
                  // ignore: unused_local_variable wait
                  final messageText = message.data()['text'];
                  final messageSender = message.data()['sender'];
                  final messageBubble =
                      MessageBubble(sender:messageSender, text:messageText);
                  messageBubbles.add(messageBubble);
                } // kro thik fir ye hi pata chala ki return ko loop ke bhr rkh do bss thnkuuu smjh mein aayahnjir  sure?ji ok ab  ek last cheez kya
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15.0,
                    ),
                    child: ListView(
                      children:
                          messageBubbles, // har baar return ho rhi hai value hnor loop ki last value hi print hui ha bss ok ye last msg tha hn yeha par out put random hai ok
                    ),
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      //messageText+loggedInUserEmail
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
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

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text});
  final String sender;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
              Text(sender,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),),
              Material(
          borderRadius: BorderRadius.circular(30),
          elevation: 5,
          color: Colors.lightBlueAccent,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal:20.0,vertical: 10),
            child: Text(
              '$text',
              style: TextStyle(fontSize: 20,
              color: Colors.white),
            ),
          ),
        ),
      ],
      ),
    );
  }
}