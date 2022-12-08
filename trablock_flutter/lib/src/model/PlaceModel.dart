import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  late String name;
  late int hour;
  late int minute;

  Place({required this.name, required this.hour, required this.minute});

  factory Place.fromDocument(DocumentSnapshot documentSnapshot) {
    return Place(
      name: documentSnapshot.get("name"),
      hour: documentSnapshot.get("hour"),
      minute: documentSnapshot.get("minute")
    );
  }
}