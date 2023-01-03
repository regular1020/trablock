import 'package:flutter/material.dart';

class AddPlanViewProvider with ChangeNotifier {
  late String? _dropDownValue = '기타';

  String? get dropDownValue => _dropDownValue;

  void setDropDownValue(String? value) {
    _dropDownValue = value;
    notifyListeners();
  }
}