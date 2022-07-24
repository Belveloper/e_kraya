import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _fireStore = FirebaseFirestore.instance;
User loggedInUser;
var sendIcon;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  String messageText;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();

  }

  void getCurrentUser()   {

    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email.trim());
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forum de discussion e-9raya',
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        titleSpacing: 3.0,
      ),
      body: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StreamBuilder(
                    stream: _fireStore.collection('Messages').snapshots(),
                    builder: (context, snapshot) {
                      if(!snapshot.hasData){
                        Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.greenAccent.shade100,
                            ));
                      }
                      final messages = snapshot.data.docs.reversed;
                      List<MessageChatBubble> messageWidgets = [];
                      for (var message in messages) {
                        final messageText = message['text'];
                        final messageSender = message['sender'];
                        final messageTime = message['time'];
                        final currentUser = loggedInUser.email ;
                        if (currentUser == messageSender) {
                          //we check if the user is the same as the sender,
                        }

                        final messageWidget = MessageChatBubble(
                          sender: messageSender,
                          text: messageText,
                          date: messageTime,
                          isUser: currentUser == messageSender,
                        );
                        messageWidgets.add(messageWidget);
                        messageWidgets.sort((a, b) => b.date.compareTo(a.date));
                      }
                      return Expanded(
                        child:ListView(
                            reverse: true,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20.0),
                            children:  messageWidgets),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: messageController,
                    onChanged: (value) {
                      setState(() {
                        messageText = value;
                        print(messageText);
                      });
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(13.0)),
                          borderSide: BorderSide(width: 1, color: Colors.green),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(13.0)),
                          borderSide: BorderSide(width: 2, color: Colors.green),
                        ),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(13.0),
                        ),
                        contentPadding: EdgeInsets.only(top: 15.0, left: 10.0),
                        hintText: 'Entrer un message ...',
                        suffixIcon: messageController.text.isEmpty?null
                            : IconButton(
                                onPressed: () {


                                  if (messageText.isNotEmpty) {
                                    _fireStore.collection('Messages').add({
                                      'sender': loggedInUser.email.trim(),
                                      'text': messageText,
                                      'time': DateTime.now(),
                                    });

                                   setState(() {
                                     messageController.clear();
                                   });
                                  }
                                },
                                icon: Icon(
                                  Icons.send_rounded,
                                  color: Colors.green,
                                ),
                              )
                            ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MesssageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _fireStore.collection('Messages').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {}

          final messages = snapshot.data.docs.reversed;
          List<MessageChatBubble> messageWidgets = [];

          for (var message in messages) {
            final messageText = message['text'];
            final messageSender = message['sender'];
            final messageTime = message['time'];
            final messageWidget = MessageChatBubble(
              sender: messageSender,
              text: messageText,
              date: messageTime,
            );
            messageWidgets.add(messageWidget);
          }
          return Expanded(
            child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20.0),
                children: messageWidgets),
          );
        });
  }
}

// ignore: must_be_immutable
class MessageChatBubble extends StatelessWidget {
  final String sender;
  final String text;
  final Timestamp date;

  bool isUser;
  MessageChatBubble({Key key, this.sender, this.text, this.date, this.isUser});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            elevation: 5,
            borderRadius: isUser
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
            color: isUser ? Colors.green : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                '$text',
                style: TextStyle(
                    color: isUser ? Colors.white : Colors.black,
                    fontSize: 15.0),
              ),
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            '${date.toDate().month}/${date.toDate().day}\t ${date.toDate().hour}:${date.toDate().minute}',
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          )
        ],
      ),
    );
  }
}
