import 'package:cloud_firestore/cloud_firestore.dart';

class Travel {
  late String owner;
  late String destination;
  late String period;
  late int numberOfPeople;

  Travel({required this.owner, required this.destination, required this.period, required this.numberOfPeople});

  factory Travel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    return Travel(
      owner: documentSnapshot.get("owner"),
      destination: documentSnapshot.get("destination"),
      period: documentSnapshot.get("period"),
      numberOfPeople: documentSnapshot.get("numberOfPeople")
    );
  }
}