import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider with ChangeNotifier {
  final storage = const FlutterSecureStorage();

  var db = FirebaseFirestore.instance;

  String? _id;
  String? _nickname;

  String? get id => _id;
  String? get nickname => _nickname;

  void setID (String id) {
    _id = id;
    storage.write(key: "userID", value: id);
    notifyListeners();
  }

  Future<void> checkID () async {
    try {
      var doc = await db.collection("user").doc(id).get();
      if (doc.exists) {
        var docRef = await db.collection("user").doc(id).get();
        _nickname = docRef.get("nick");
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }

  readUserIDFromLocal() async {
    _id = await storage.read(key: "userID");
    notifyListeners();
  }

  void addUserNickNameToFireStore(String id, String nick) {
    final data = {"nick" : nick};
    db.collection("user").doc(id).set(data);
    _nickname = nick;
    notifyListeners();
  }
}