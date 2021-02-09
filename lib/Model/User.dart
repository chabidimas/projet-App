import 'package:firebase_database/firebase_database.dart';

class User {

  String id;
  String prenom;
  String nom;
  String imageUrl;
  String initiales;

  User(DataSnapshot snapshot) {
    Map map = snapshot.value;
    prenom = map["prenom"];
    id = map["uid"];
    nom = map["nom"];
    imageUrl = map["imageUrl"];
    if (prenom != null && prenom.length > 0) {
      initiales = prenom[0];
    }
    if (nom != null && nom.length > 0) {
      if (initiales != null) {
        initiales += nom[0];
      } else {
        initiales = nom[0];
      }
    }
  }


  Map toMap() {
    return {
      "prenom": prenom,
      "nom": nom,
      "imageUrl": imageUrl,
      "uid": id
    };
  }
}