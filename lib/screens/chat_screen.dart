import 'package:flutter/material.dart';
import 'package:flashh_chat/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {

  //adding static now means id is not an object anymore, it is associated with class
  // so instead of LoginScreen().id it will be LoginScreen.id
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late String texts;

  void getCurrentUser() async {
    try{
      print('will be waiting');
      final user = await  _auth.currentUser;
      print('shall be waiiting again');
      if (user!=null) {
        print('last waiting');
        loggedInUser = await user;
        print(loggedInUser.email);
      }
    }
    catch(e)
    {print(e);}
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    getCurrentUser();
  }

   void messagesStream() async {
     await for (var snapshot in _firestore.collection('messages').snapshots()){
       for (var message in snapshot.docs){
         print(message.data().cast());
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
                _auth.signOut();
                Navigator.pop(context);
               messagesStream();
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
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        texts = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                     setState(() {
                       messageTextController.clear();
                       _firestore.collection('messages').add({
                         'sender' : loggedInUser.email,
                         'text' : texts,
                       });
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

class MessageStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        List<MessageBubble> messageBubbles = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.pink.shade500,
            ),
          );
        }
        else {
          //! is telling that there's definitely some data there
          final messages = snapshot.data!.docs.reversed;

          for (var message in messages) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final currentUser = loggedInUser.email;

            final messageBubbleWidget = MessageBubble(
                text: messageText,
                sender: messageSender,
                isMe: currentUser==loggedInUser,
            );

            messageBubbles.add(messageBubbleWidget);
          }
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {

  MessageBubble({required this.text , required this.sender, required this.isMe });

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment: isMe?  CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w300,
              color: Colors.black54,
            ),),
          Material(
            borderRadius: BorderRadius.only(
              topLeft: isMe? Radius.circular(30.0) : Radius.circular(0.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              topRight: isMe ? Radius.circular(0.0) : Radius.circular(30.0),
            ),
            elevation: 6.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 15.0,
                  color: isMe ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
