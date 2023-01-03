import 'package:flutter/material.dart';

class PlanDragStateProvider with ChangeNotifier {
  bool _moved = false;

  bool get moved => _moved;

  void moveStart() {
    _moved = true;
    notifyListeners();
  }

  void moveEnd() {
    _moved =false;
    notifyListeners();
  }

}