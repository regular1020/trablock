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

  Future<void> checkIDFromFirebase() async {
    try {
      var doc = await db.collection("user").doc(_id).get();
      if (doc.exists) {
        _nickname = doc.get("nick");
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> readUserIDFromLocal() async {
    _id = await storage.read(key: "userID");
    if (_id == null) {
      notifyListeners();
      return true;
    } else{
      return false;
    }
  }

  Future<int> getRoutingFlagFromUserInformation() async {
    await readUserIDFromLocal();
    await checkIDFromFirebase();
    if (_id == null) {
      return 1;
    }
    if (_nickname == null) {
      return 2;
    }
    return 3;
  }

  void addUserNickNameToFireStore(String id, String nick) {
    final data = {"nick" : nick};
    db.collection("user").doc(id).set(data);
    _nickname = nick;
    notifyListeners();
  }
}