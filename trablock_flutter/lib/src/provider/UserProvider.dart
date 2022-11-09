import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider with ChangeNotifier {
  final storage = const FlutterSecureStorage();

  String? _id;
  String? _nickname;

  void setID (String id) {
    _id = id;
    storage.write(key: "userID", value: id);
    notifyListeners();
  }

  void setNickName (String nickname) {
    _nickname = nickname;
    storage.write(key: "userNickName", value: nickname);
    notifyListeners();
  }

  String? get id => _id;
  String? get nickname => _nickname;

  asyncMethod() async {
    _id = await storage.read(key: "userID");
    _nickname = await storage.read(key: "userNickName");
  }
}