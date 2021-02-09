import 'package:flutterchat/Model/User.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterchat/Model/DateHelper.dart';

class Conversation {

  String id;
  String last_message;
  String date;
  User user;

  Conversation(DataSnapshot snapshot) {
    this.id = snapshot.value["monId"];
    String stringDate = snapshot.value["dateString"];
    this.date = DateHelper().getDate(stringDate);
    this.last_message = snapshot.value["last_message"];
    user = new User(snapshot);
  }


}