import 'package:flutter/material.dart';
import 'package:flutterchat/Model/Message.dart';
import 'package:flutterchat/Model/User.dart';
import 'package:flutterchat/Widgets/CustomImage.dart';

class ChatBubble extends StatelessWidget {

  Message message;
  User partenaire;
  String monId;
  Animation animation;

  ChatBubble(String id, User partenaire, Message message, Animation animation) {
    this.message = message;
    this.partenaire = partenaire;
    this.monId = id;
    this.animation = animation;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(parent: animation, curve: Curves.easeIn),
      child: new Container(
        margin: EdgeInsets.all(10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: widgetsBubble(message.from == monId),
        ),
      ),
    );
  }

  List<Widget> widgetsBubble(bool moi) {
    CrossAxisAlignment alignement = (moi)? CrossAxisAlignment.end: CrossAxisAlignment.start;
    Color bubbleColor = (moi)? Colors.pink[100]: Colors.blue[400];
    Color textColor = (moi)? Colors.black : Colors.grey[200];

    return <Widget> [
      moi ? new Padding(padding: EdgeInsets.all(8.0)) : new CustomImage(partenaire.imageUrl, partenaire.initiales, 15.0),
      new Expanded(
          child: new Column(
            crossAxisAlignment: alignement,
            children: <Widget>[
              new Text(message.dateString),
              new Card(
                elevation: 5.0,
                shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                color: bubbleColor,
                child: new Container(
                  padding: EdgeInsets.all(10.0),
                  child: (message.imageUrl == null)
                      ? new Text(
                      message.text ?? "",
                    style: new TextStyle(
                      color: textColor,
                      fontSize: 15.0,
                      fontStyle: FontStyle.italic
                    ),
                  )
                      : new CustomImage(message.imageUrl, null, null)
                  ,
                ),
              )
            ],
          ))
    ];
  }

}