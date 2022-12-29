import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  late String id;
  late String name;
  late int hour;
  late int minute;
  late int dateOfVisit;
  late int index;
  late String category;

  Place({required this.id, required this.name, required this.hour, required this.minute, required this.dateOfVisit, required this.index, required this.category});

  factory Place.fromDocument(DocumentSnapshot documentSnapshot) {
    return Place(
      id: documentSnapshot.id,
      name: documentSnapshot.get("name"),
      hour: documentSnapshot.get("hour"),
      minute: documentSnapshot.get("minute"),
      dateOfVisit: documentSnapshot.get("date_of_visit"),
      index: documentSnapshot.get("index"),
      category: documentSnapshot.get("category")
    );
  }
}