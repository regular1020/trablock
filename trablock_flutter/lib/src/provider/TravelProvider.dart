import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trablock_flutter/src/model/TravelModel.dart';

class TravelProvider with ChangeNotifier {
  List<Travel> _travels = [];
  late Travel _selectedTravel;

  Travel get travel => _selectedTravel;

  void selectTravel(Travel travel) {
    _selectedTravel = travel;
  }

  final _db = FirebaseFirestore.instance;

  List<Travel> get travels => _travels;

  void readTravelFromFireStore(String id) async {
    _travels = [];
    var query = _db.collection("travel").where("owner", isEqualTo: id);
    var doc = await query.get();
    for (var element in doc.docs) {
      _travels.add(Travel.fromSnapshot(element));
    }
    notifyListeners();
  }

  void addTravel(Travel travel) {
    _travels.add(travel);
    notifyListeners();
  }

  void addTravelToFireStore(String ownerID, String destination, int numberOfPeople, String period, int days) async {
    String id = "";
    final data = {
      "owner" : ownerID,
      "destination" : destination,
      "numberOfPeople" : numberOfPeople,
      "period" : period,
      "days" : days
    };
    await _db.collection("travel").add(data).then((documentSnapshot) {
      id = documentSnapshot.id;
    });
    _selectedTravel = Travel(id: id, owner: ownerID, destination: destination, period: period, days: days, numberOfPeople: numberOfPeople, places: []);
    _travels.add(_selectedTravel);
    notifyListeners();
  }
}