import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Travel _testTravel(){
  // 테스트용
  Travel res = Travel('test');
  res.days = [
    [
      Destination(name: 'Gyeongbokgung', address: LatLng(37.576267, 126.976912)),
      Destination(name: 'Seoul Station', address: LatLng(37.555078,126.970702))
    ],
    [
      Destination(name: 'Gangnam', address: LatLng(37.498095,127.027610)),
      Destination(name: '63 building', address: LatLng(37.310976,126.562476))
    ]
  ];
  return res;
}

final List<Travel> myTravelList = [_testTravel()]; // 로컬 데이타베이스에서 불러올 예정

class Travel {
  // 각각의 여행. Destination, TimeTag 정보를 포함한다.
  String title;
  List<List<Destination>> days = [];
  List<List<TimeTag>> tags = [];

  List<Destination> candidateDestination = [];

  Travel(this.title);
}

abstract class Insertable {
  // 블럭 사이에 입력 가능한 객체
  Widget getWidget({bool whenDragging = false});
}

class Destination extends Insertable{
  // 각각의 여행지.
  static final double widgetWidth = 200;
  static final double widgetHeight = 60;

  String name;
  LatLng address; //여행지의 좌표

  TimeTag timeTag = TimeTag.nullTag;

  List<int> blockColor = [0, 0, 0];

  Destination({String name, LatLng address})
    : this.name = name,
      this.address = address {
    Random _random = Random();
    blockColor[0] = _random.nextInt(206) + 50;
    blockColor[1] = _random.nextInt(206) + 50;
    blockColor[2] = _random.nextInt(206) + 50;
  }
  @override
  Widget getWidget({whenDragging = false}) {
    return Container(
      width: widgetWidth,
      height: widgetHeight,
      color: whenDragging
        ? Color.fromRGBO(blockColor[0], blockColor[1], blockColor[2], 0.3)
        : Color.fromRGBO(blockColor[0], blockColor[1], blockColor[2], 1),
      child: Center(child: Text(
        name,
        style: TextStyle(
          fontSize: 20,
          color: whenDragging
            ? Colors.grey
            : Colors.black,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal
        ),
      ),
    ));
  }
}

class TimeTag implements Insertable{
  // Destination 시작과 끝의 시간 정보(Optional)
  static final double widgetWidth = 60;
  static final double widgetHeight = 30;

  static final TimeTag nullTag = TimeTag(time: null);
  String time0;
  String time1;

  // Default constructor
  TimeTag({@required String time, String timeExtra})
      : time0 = time,
        time1 = timeExtra;
  // Copy constructor
  TimeTag.copy(TimeTag src)
      : this(time: src.time0, timeExtra: src.time1);

  @override
  Widget getWidget({whenDragging = false}) {
    if(this == nullTag)
      return Container(width: widgetWidth, height: 0,);
    return Container(
      width: widgetWidth,
      height: widgetHeight,
      color: Colors.blue,
      child: Text(
        time0,
        style: TextStyle(
          fontSize: 10,
          color: whenDragging
            ? Colors.grey
            : Colors.black,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal
        ),
      ),
    );
  }
}