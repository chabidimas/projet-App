import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutterchat/Model/FirebaseHelper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterchat/Model/User.dart';
import 'package:flutterchat/Widgets/CustomImage.dart';
import 'package:flutterchat/Controller/ChatController.dart';

class ContactController extends StatefulWidget {

  String id;

  ContactController(String id) {
    this.id = id;
  }

  ContactControllerState createState() => new ContactControllerState();

}

class ContactControllerState extends State<ContactController> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new FirebaseAnimatedList(
        query: FirebaseHelper().base_user,
        sort: (a, b) => a.value["prenom"].compareTo(b.value["prenom"]),
        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
          User newUser = new User(snapshot);
          if (newUser.id == widget.id) {
            // C'est nous
            return new Container();
          } else {
            // C'est pas nous
            return new ListTile(
              leading: new CustomImage(newUser.imageUrl, newUser.initiales, 20.0),
              title: new Text("${newUser.prenom}  ${newUser.nom}"),
              trailing: new IconButton(icon: new Icon(Icons.message), onPressed: () {
                // Envoie vers le controller de Chat pour discuter.
                Navigator.push(context, new MaterialPageRoute(builder: (context) => new ChatController(widget.id, newUser)));
              }),
            );
          }
        }
    );
  }
}