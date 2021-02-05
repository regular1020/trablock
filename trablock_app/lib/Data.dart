import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Travel _testTravel(){
  // 테스트용
  Travel res = Travel('test');
  res.days = [
    [
      Destination('Gyeongbokgung', address: LatLng(37.576267, 126.976912)),
      Destination('Seoul Station', address: LatLng(37.555078,126.970702), planType: Destination.type_movement)
    ],
    [
      Destination('Gangnam', address: LatLng(37.498095,127.027610)),
      Destination('63 building', address: LatLng(37.310976,126.562476), planType: Destination.type_activity)
    ]
  ];
  res.candidateDestination.add(Destination('candidate1', planType: Destination.type_food));
  return res;
}

final List<Travel> myTravelList = [_testTravel()]; // 로컬 데이타베이스에서 불러올 예정

class Travel {
  // 각각의 여행. Destination, TimeTag 정보를 포함한다.
  String title;
  bool isSelected = false;
  List<List<Destination>> days = [];
  List<Destination> candidateDestination = [];

  Travel(this.title);
}

class Destination{
  static const IconData type_none = null;
  static const IconData type_food = Icons.restaurant;
  static const IconData type_movement = Icons.alt_route;
  static const IconData type_activity = Icons.auto_awesome;

  static final Random _random = Random();
  // 각각의 여행지.

  String name;
  LatLng address; //여행지의 좌표
  IconData planType;
  List<int> blockColor;

  // Default constructor
  Destination(this.name, {LatLng address, IconData planType})
    : this.address = address, this.planType = planType {
    blockColor.add(_random.nextInt(206) + 50);
    blockColor.add(_random.nextInt(206) + 50);
    blockColor.add(_random.nextInt(206) + 50);
  }
  // Copy constructor
  Destination.copy(Destination src) {
    this.name = src.name;
    this.address = src.address;
    this.blockColor = src.blockColor;
    this.planType = src.planType;
  }
}
