import 'package:flutter/material.dart';

class AddTravelViewProvider with ChangeNotifier {
  String _currencyCode = "KRW";

  void setCode(String code) {
    _currencyCode = code;
    notifyListeners();
  }

  String get currencyCode => _currencyCode;
}