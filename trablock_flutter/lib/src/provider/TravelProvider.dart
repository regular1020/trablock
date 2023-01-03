import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trablock_flutter/src/model/PlaceModel.dart';
import 'package:trablock_flutter/src/model/TravelModel.dart';

class TravelProvider with ChangeNotifier {
  List<Travel> _travels = [];
  late Travel _selectedTravel;

  final _db = FirebaseFirestore.instance;

  List<Travel> get travels => _travels;
  Travel get selectedTravel => _selectedTravel;

  void selectTravel(String id) {
    for (int i = 0; i < _travels.length; i++) {
      if (_travels[i].id == id) {
        _selectedTravel = _travels[i];
        break;
      }
    }
  }

  void addTravel(Travel travel) {
    _travels.add(travel);
    notifyListeners();
  }

  void readTravelFromFireStore(String id) async {
    _travels = [];
    var query = _db.collection("travel").where("owner", isEqualTo: id);
    var doc = await query.get();
    for (var element in doc.docs) {
      List<DocumentSnapshot> placeDocs = [];
      try{
        var refList = element.get("places");
        for (var documentReference in refList) {
          var placeDoc = await documentReference.get();
          placeDocs.add(placeDoc);
        }
      } catch(e) {

      }
      _travels.add(Travel.fromSnapshot(element, placeDocs));
    }
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

  void saveChangeToFireStore(Place place) {
    final docRef = _db.collection("place").doc(place.id);
    final updates = <String, dynamic>{
      "date_of_visit" : place.dateOfVisit,
      "index" : place.index,
      "hour" : place.hour,
      "minute" : place.minute,
      "name" : place.name
    };
    try {
      docRef.update(updates);
    } catch (e) {
      _db.collection("place").add(updates).then((value) =>
          _db.collection("travel").doc(_selectedTravel.id).update({
            "places" : FieldValue.arrayUnion([value.id])
          })
      );
    }
  }
}