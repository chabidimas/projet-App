import 'package:flutter/material.dart';
import 'package:flutterchat/Model/User.dart';
import 'package:flutterchat/Widgets/CustomImage.dart';
import 'package:flutterchat/Widgets/ZoneDeTexteWidget.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutterchat/Model/FirebaseHelper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterchat/Model/Message.dart';
import 'package:flutterchat/Widgets/ChatBubble.dart';

class ChatController extends StatefulWidget {

  String id;
  User partenaire;

  ChatController(String id, User partenaire) {
    this.id = id;
    this.partenaire = partenaire;
  }

  ChatControllerState createState() => new ChatControllerState();
}

class ChatControllerState extends State<ChatController> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new CustomImage(widget.partenaire.imageUrl, widget.partenaire.initiales, 15.0),
          new Text(widget.partenaire.prenom)
        ],
      ),
      ),
      body: new Container(
        child: new InkWell(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: new Column(
            children: <Widget>[
              // Zone de chat
              new Flexible(
                  child: new FirebaseAnimatedList(
                      query: FirebaseHelper().base_message.child(FirebaseHelper().getMessageRef(widget.id, widget.partenaire.id)),
                      reverse: true,
                      sort: (a, b) => b.key.compareTo(a.key),
                      itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                        Message message = new Message(snapshot);
                        print(message.text);
                        return new ChatBubble(widget.id, widget.partenaire, message, animation);
                      })
              ),
              new Divider(height: 1.5,),
              new ZoneDeTexteWidget(widget.partenaire, widget.id)

            ],
          ),
        ),
      ),
    );
  }

}