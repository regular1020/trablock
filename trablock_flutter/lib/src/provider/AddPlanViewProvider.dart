import 'package:flutter/material.dart';

class AddPlanViewProvider with ChangeNotifier {
  String? _dropDownValue = '기타';
  String _currencyCode = "선택";

  String? get dropDownValue => _dropDownValue;
  String get currencyCode => _currencyCode;

  void setDropDownValue(String? value) {
    _dropDownValue = value;
    notifyListeners();
  }

  void setCurrencyCode(String value) {
    _currencyCode = value;
    notifyListeners();
  }
}