import 'dart:math';

import 'package:flutter/material.dart';

Travel _testTravel(){
  // 테스트용
  Travel res = Travel('test');
  res.days = [[Destination('aaaa'), Destination('bbbb')],[Destination('Seoul'),Destination('Busan')]];
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
  String address;
  TimeTag timeTag = TimeTag.nullTag;

  List<int> blockColor = [0, 0, 0];

  Destination(this.name) {
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
      child: Text(name),
    );
  }
}

class TimeTag implements Insertable{
  // Destination 시작과 끝의 시간 정보(Optional)
  static final double widgetWidth = 60;
  static final double widgetHeight = 30;

  static final TimeTag nullTag = TimeTag(time: null);
  String time0;
  String time1;

  TimeTag({@required String time, String timeExtra})
      : time0 = time,
        time1=timeExtra;
  TimeTag.copy(TimeTag timeTag)
      : this(time: timeTag.time0, timeExtra: timeTag.time1);

  @override
  Widget getWidget({whenDragging = false}) {
    return Container(
      width: widgetWidth,
      height: this == nullTag
          ? 0
          : widgetHeight,
      color: this == TimeTag.nullTag
          ? null
          : Colors.blue,
      child: Text(
          this == TimeTag.nullTag
              ? ''
              : time0
      ),
    );
  }
}