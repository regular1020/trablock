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

class Insertable {
  // 블럭 사이에 입력 가능한 객체
}

class Destination extends Insertable{
  // 각각의 여행지.
  String name;
  String address;
  TimeTag timeTag = TimeTag.nullTag;

  Destination(this.name);
}

class TimeTag extends Insertable{
  // Destination 시작과 끝의 시간 정보(Optional)
  static final TimeTag nullTag = TimeTag(time: null);
  String time0;
  String time1;

  TimeTag({@required String time, String timeExtra})
      : time0 = time,
        time1=timeExtra;
}