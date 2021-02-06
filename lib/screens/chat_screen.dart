import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/test.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'registration_screen.dart';
// import 'package:flash_chat/screens/registration_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
} //shi ordermein ni hore uske liye to hume data base clear karna tha

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  static double latitude;
  static double longitude;
  String messageText;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getLocation();
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    latitude = position.latitude;
    longitude = position.longitude;
    // print(position);

    // print('testing');
  }

  toastFun() {
    Fluttertoast.showToast(
        msg: "latitude: $latitude, longitude: $longitude",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Color(0xff0581CC),
        fontSize: 16.0);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                      child: Image.asset('images/icon3.png'),
                      height: 30.0,
                    ),
                    Text(
                      'Chats',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontFamily: 'Pacifico',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                        color: Color(0xff0581CC),
                      ),
                    ),
                    SizedBox(
                      width: 150.0,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 35.0,
                        color: Color(0xff0581CC),
                      ),
                      onPressed: () {
                        // _auth.signOut();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(// suno bolo agr hm smjh aya? kya latitude longitude ko container ke bhr print krvade toh ye dekho
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          color: Color(0xff0581CC),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MessageStream(),
                              // Text(  // ye chahiye hme bss ho gyaa ab tohhh tumhara hua dear apka krte h ab tum karogi mere sath? puchra hu hn ok fir aao ok mein emlator bndkrdoo???????
                              //   // 'Testing container',
                              //   'latitude: $latitude \nlongitude: $longitude',  // kuch or changes karne hai?ni dekho phle 2 mins 
                              //   style: TextStyle(
                              //       fontFamily: 'Pacifico',
                              //       letterSpacing: 2.0,
                              //       fontSize: 18.0,
                              //       color: Colors.white,
                              //       ),
                              // ),
                              // Text(
                              //   'Testing container',
                              //   style: TextStyle(
                              //       fontFamily: 'Pacifico',
                              //       letterSpacing: 2.0,
                              //       fontSize: 18.0,
                              //       color: Colors.white),
                              // ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: messageTextController,
                                      onChanged: (value) {
                                        //Do something with the user input. build hua?hora h
                                        messageText = value;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Type a Message',
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        fillColor: Colors.white,
                                        focusColor: Colors.white,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 20.0,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2.0)),
                                      ),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      messageTextController.clear();
                                      //Implement send functionality.
                                      //messageText+loggedInUserEmail
                                      _firestore.collection('messages').add({
                                        'text': messageText,
                                        'sender': loggedInUser.email,
                                      });
                                      toastFun();
                                    },

                                    // SizedBox(
                                    //   width: 10.0,
                                    // ),
                                    // child: Text(
                                    //   'Send',
                                    //   style: kSendButtonTextStyle,
                                    // ),
                                    child: Icon(
                                      Icons.send,
                                      size: 30.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
        final messages = snapshot.data.docs.reversed;

        // ignore: unused_local_variable
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          // ignore: unused_local_variable wait
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];
          final currentUser = loggedInUser.email;
          // if (currentUser == messageSender) {
          //   //the message from loggedin user
          // }
          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        } // kro thik fir ye hi pata chala ki return ko loop ke bhr rkh do bss thnkuuu smjh mein aayahnjir  sure?ji ok ab  ek last cheez kya
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 15.0,
            ),
            child: ListView(
              reverse: true,
              children:
                  messageBubbles, // har baar return ho rhi hai value hnor loop ki last value hi print hui ha bss ok ye last msg tha hn yeha par out put random hai ok
            ),
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            elevation: 5,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text(
                '$text',
                style: TextStyle(
                    fontSize: 20, color: isMe ? Colors.white : Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
/*

Expanded(
                      child: ListView(
                        padding:EdgeInsets.symmetric(horizontal: 5,vertical: 5) ,
                      children: messageWidgets, ruko 5mins baat karta hu tumse bolo
                    ), 
                  );
kya hua? problem kya hai? merko koi issue nhi?mjhe ni lena arey claim to karo na ek baar agar aana ho  jb vo mra h hi nhi
                  */
