import 'package:cloud_firestore/cloud_firestore.dart';

import 'PlaceModel.dart';

class Travel {
  late String id;
  late String owner;
  late String destination;
  late String period;
  late int days;
  late int numberOfPeople;
  late List<Place> places;

  Travel({required this.id, required this.owner, required this.destination, required this.period, required this.days, required this.numberOfPeople, required this.places});

  factory Travel.fromSnapshot(DocumentSnapshot travelSnapshot) {
    return Travel(
      id: travelSnapshot.id,
      owner: travelSnapshot.get("owner"),
      destination: travelSnapshot.get("destination"),
      period: travelSnapshot.get("period"),
      days: travelSnapshot.get("days"),
      numberOfPeople: travelSnapshot.get("numberOfPeople"),
      places: []
    );
  }
}