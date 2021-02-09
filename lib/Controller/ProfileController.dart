import 'package:flutter/material.dart';
import 'package:flutterchat/Model/User.dart';
import 'package:flutterchat/Model/FirebaseHelper.dart';
import 'package:flutterchat/Widgets/CustomImage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class ProfileController extends StatefulWidget {

  String id;

  ProfileController(String id) {
    this.id = id;
  }

  ProfileControllerState createState() => new ProfileControllerState();

}

class ProfileControllerState extends State<ProfileController> {

  User user;
  String prenom;
  String nom;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return (user == null)
        ? new Center( child: new Text("Chargement..."))
        : new SingleChildScrollView(
      child: new Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Image
            new CustomImage(user.imageUrl, user.initiales, MediaQuery.of(context).size.width / 5),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new IconButton(
                    icon: new Icon(Icons.camera_enhance),
                    onPressed: () {
                      _takePicture(ImageSource.camera);
                    }),
                new IconButton(
                    icon: new Icon(Icons.photo_library),
                    onPressed: () {
                      _takePicture(ImageSource.gallery);
                    })
              ],
            ),
            new TextField(
              decoration: new InputDecoration(hintText: user.prenom),
              onChanged: (string) {
                setState(() {
                  prenom = string;
                });
              },
            ),
            new TextField(
              decoration: new InputDecoration(hintText: user.nom),
              onChanged: (string) {
                setState(() {
                  nom = string;
                });
              },
            ),
            new RaisedButton(
              color: Colors.blue,
                onPressed: _saveChanges,
              child: new Text("Sauvegarder les changements", style: new TextStyle(color: Colors.white, fontSize: 20.0),),
            ),
            new FlatButton(
                onPressed: () {
                  _logOut(context);
                },
                child: new Text("Se déconnecter", style:  new TextStyle(color: Colors.blue, fontSize: 20.0),))
          ],
        ),
      ),
    );
  }

  _saveChanges() {
    Map map = user.toMap();
    if (prenom != null && prenom != "") {
      map["prenom"] = prenom;
    }
    if (nom != null && nom != "") {
      map["nom"] = nom;
    }
    FirebaseHelper().addUser(user.id, map);
    _getUser();
  }

  Future<void> _takePicture(ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source, maxWidth: 500.0, maxHeight: 500.0);
    // Obtenir une Url après avoir ajouté image dans le stockage.
    FirebaseHelper().savePicture(image, FirebaseHelper().storage_users.child(widget.id)).then((string) {
      Map map = user.toMap();
      map["imageUrl"] = string;
      FirebaseHelper().addUser(user.id, map);
      _getUser();
    });
  }

  Future<void> _logOut(BuildContext context) async {
    Text title = new Text("Se déconnecter");
    Text subtitle = new Text(("Etes-vous sur?"));
    return showDialog(
        context: context,
      barrierDismissible: false,
      builder: (BuildContext build) {
        return (Theme.of(context).platform == TargetPlatform.iOS) 
            ? new CupertinoAlertDialog(title: title, content: subtitle, actions: _actions(build),)
            : new AlertDialog(title: title, content: subtitle, actions: _actions(build),);
      }
    );
  }
  
  List<Widget> _actions(BuildContext build) {
    List<Widget> widgets = [];
    widgets.add(new FlatButton(
        onPressed: () {
          FirebaseHelper().handleLogOut().then((bool) {
            Navigator.of(build).pop();
          });
        }, 
        child: new Text("OUI"))
    );
    widgets.add(new FlatButton(
        onPressed: () => Navigator.of(build).pop(),
        child: new Text("NON"))
    );
    return widgets;
  }
  
  


  _getUser() {
    FirebaseHelper().getUser(widget.id).then((user) {
      setState(() {
        this.user = user;
      });
    });
  }

}