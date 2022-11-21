import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trablock_flutter/src/model/TravelModel.dart';

class TravelProvider with ChangeNotifier {
  List<Travel> _travels = [];

  var db = FirebaseFirestore.instance;

  List<Travel> get travels => _travels;

  void readTravelFromDB(String id) async {
    var query = db.collection("travel").where("owner", isEqualTo: id);
    var doc = await query.get();
    List<Travel> travelList = [];
    for (var element in doc.docs) {
      travelList.add(Travel.fromSnapshot(element));
    }
    _travels = travelList;
    notifyListeners();
  }
}