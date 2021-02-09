import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterchat/Model/User.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutterchat/Model/User.dart';


class FirebaseHelper {

  // Authentification

  final auth = FirebaseAuth.instance;

  Future<FirebaseUser> handleSignIn(String mail, String password) async {
    final AuthResult result = await auth.signInWithEmailAndPassword(email: mail, password: password) ;
    final FirebaseUser user = result.user;
    return user;
  }

  Future<FirebaseUser> handleCreate(String mail, String password, String prenom, String nom) async {
    final AuthResult result= await auth.createUserWithEmailAndPassword(email: mail, password: password);
    final FirebaseUser user = result.user;
    String uid = user.uid;
    Map<String, String> map = {
      "uid": uid,
      "prenom": prenom,
      "nom": nom
    };
    addUser(uid, map);
    return user;
  }

  Future<bool> handleLogOut() async {
    await auth.signOut();
    return true;
  }


  Future<String> myId() async {
    FirebaseUser user = await auth.currentUser();
    return user.uid;
  }


  //Database

  static final base = FirebaseDatabase.instance.reference();
  final base_user = base.child("users");
  final base_message = base.child("messages");
  final base_conversation = base.child("conversations");


  addUser(String uid, Map map) {
    base_user.child(uid).set(map);
  }

  Future<User> getUser(String id) async {
    DataSnapshot snapshot = await base_user.child(id).once();
    return new User(snapshot);
  }

  sendMessage(User user, User moi, String text, String imageUrl) {
    String date = new DateTime.now().millisecondsSinceEpoch.toString();
    Map map = {
      "from": moi.id,
      "to": user.id,
      "text": text,
      "imageUrl": imageUrl,
      "dateString": date
    };
    base_message.child(getMessageRef(moi.id,user.id)).child(date).set(map);
    base_conversation.child(moi.id).child(user.id).set(getConversation(moi.id, user, text, date));
    base_conversation.child(user.id).child(moi.id).set(getConversation(moi.id, moi, text, date));
  }

  Map getConversation(String sender, User user, String text, String dateString) {
    Map map = user.toMap();
    map["monId"] = sender;
    map["last_message"] = text;
    map["dateString"] = dateString;
    return map;
  }

  String getMessageRef(String from, String to) {
    String resultat = "";
    List<String> liste = [from, to];
    liste.sort((a, b) => a.compareTo(b));
    for (var x in liste) {
      resultat += x + "+";
    }
    return resultat;
  }

  //Storage
  static final base_storage = FirebaseStorage.instance.ref();
  final StorageReference storage_users = base_storage.child("users");
  final StorageReference storage_messages = base_storage.child("messages");


  Future<String> savePicture(File file, StorageReference storageReference) async {
    StorageUploadTask storageUploadTask = storageReference.putFile(file);
    StorageTaskSnapshot snapshot = await storageUploadTask.onComplete;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

}