import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trablock_flutter/src/model/PlaceModel.dart';
import 'package:trablock_flutter/src/model/TravelModel.dart';

class SelectedTravelProvider with ChangeNotifier {
  late Travel _travel;
  late List<Place> _unassignedPlaces;
  late List<List<Place>> _assignedPlaces;

  final _db = FirebaseFirestore.instance;

  void selectTravel(Travel travel) {
    _travel = travel;
  }

  Travel get travel => _travel;
  List<Place> get unassignedPlaces => _unassignedPlaces;
  List<List<Place>> get assignedPlaces => _assignedPlaces;

  void saveChangeToFireStore(Place place) {
    final docRef = _db.collection("place").doc(place.id);
    final updates = <String, dynamic>{
      "date_of_visit": place.dateOfVisit,
      "index": place.index,
      "hour": place.hour,
      "minute": place.minute,
      "name": place.name
    };
    try {
      docRef.update(updates);
    } catch (e) {
      _db.collection("place").add(updates).then((value) => _db.collection("travel").doc(_travel.id).update({"places": FieldValue.arrayUnion([value])}));
    }
  }

  void addNewPlace(String name, int hour, int minute, String category, int? startHour, int? startMinute, String memo, String currency, int cost) {
    final updates = <String, dynamic>{
      "date_of_visit": -1,
      "index": -1,
      "hour": hour,
      "minute": minute,
      "name": name,
      "category": category,
      "start_hour": startHour,
      "start_minute": startMinute,
      "memo": memo,
      "currency": currency,
      "cost": cost,
    };
    _db.collection("place").add(updates).then((value) {
      _db.collection("travel").doc(_travel.id).update({"places": FieldValue.arrayUnion([value])});
      Place place = Place(id: value.id ,name: name, hour: hour, minute: minute, dateOfVisit: -1, index: -1, category: category, startHour: startHour, startMinute: startMinute, memo: memo, currency: currency, cost: cost);
      travel.places.add(place);
      unassignedPlaces.add(place);
      notifyListeners();
    });
  }

  void deletePlace(Place place) {
    travel.places.remove(place);
    unassignedPlaces.remove(place);
    var placeDoc = _db.collection("place").doc(place.id);
    _db.collection("travel").doc(_travel.id).update({"places" : FieldValue.arrayRemove([placeDoc])});
    placeDoc.delete();
    notifyListeners();
  }

  void initTravel() {
    _assignedPlaces = [];
    _unassignedPlaces = [];
    for (int i = 0; i < _travel.days; i++) {
      _assignedPlaces.add([]);
    }
    for (Place place in _travel.places) {
      if (place.dateOfVisit == -1) {
        _unassignedPlaces.add(place);
      } else {
        _assignedPlaces[place.dateOfVisit - 1].add(place);
      }
    }
  }

  void removePlaceFromDate(int day, int placeIndex) {
    for (int i = placeIndex + 1; i < _assignedPlaces[day-1].length; i++) {
      _assignedPlaces[day-1][i].index--;
    }
    _assignedPlaces[day-1][placeIndex].dateOfVisit = -1;
    _assignedPlaces[day-1][placeIndex].index = -1;
    _unassignedPlaces.add(_assignedPlaces[day-1].removeAt(placeIndex));
    notifyListeners();
  }

  void reorderPlace(int oldIndex, int newIndex, int dayIndex) {
    if (oldIndex < newIndex) {
      for (int i = oldIndex + 1; i <= newIndex; i++) {
        _assignedPlaces[dayIndex][i].index--;
      }
      _assignedPlaces[dayIndex][oldIndex].index = newIndex;
    } else {
      for (int i = newIndex; i < oldIndex; i++) {
        _assignedPlaces[dayIndex][i].index++;
      }
      _assignedPlaces[dayIndex][oldIndex].index = newIndex;
    }
    final Place place = _assignedPlaces[dayIndex].removeAt(oldIndex);
    _assignedPlaces[dayIndex].insert(newIndex, place);
    notifyListeners();
  }

  void insertPlace(Place place, int dayIndex) {
    place.dateOfVisit = dayIndex+1;
    place.index = _assignedPlaces[dayIndex].length;
    _assignedPlaces[dayIndex].add(place);
    _unassignedPlaces.remove(place);
    notifyListeners();
  }

  void insertPlaceAtUpperHalf(Place place, int dayIndex, int placeIndex) {
    place.dateOfVisit = dayIndex+1;
    place.index = placeIndex;
    for (int i = placeIndex; i < _assignedPlaces[dayIndex].length; i++) {
      _assignedPlaces[dayIndex][i].index++;
    }
    _assignedPlaces[dayIndex].insert(placeIndex, place);
    _unassignedPlaces.remove(place);
    notifyListeners();
  }

  void insertPlaceAtLowerHalf(Place place, int dayIndex, int placeIndex) {
    place.dateOfVisit = dayIndex+1;
    place.index = placeIndex+1;
    for (int i = placeIndex + 1;
        i < _assignedPlaces[dayIndex].length;
        i++) {
      _assignedPlaces[dayIndex][i].index++;
    }
    _assignedPlaces[dayIndex].insert(placeIndex + 1, place);
    _unassignedPlaces.remove(place);
    notifyListeners();
  }
}
