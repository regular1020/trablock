import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Travel _testTravel(){
  // 테스트용
  Travel res = Travel('test');
  res.days = [[Destination('Gyeongbokgung',LatLng(37.576267, 126.976912)), Destination('Seoul Station', LatLng(37.555078,126.970702))],[Destination('Gangnam', LatLng(37.498095,127.027610)),Destination('63 building', LatLng(37.310976,126.562476))]];
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
  LatLng address; //여행지의 좌표


<<<<<<< Updated upstream
  Destination(this.name, this.address);
=======
  Destination({@required String name, LatLng address}) {
    this.name = name;
    if(address != null)
      {
        this.address = address;
      }
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
>>>>>>> Stashed changes
}

class TimeTag extends Insertable{
  // Destination 시작과 끝의 시간 정보(Optional)
  String time0;
  String time1;

  TimeTag({@required String time, String timeExtra = ''})
      : time0 = time,
        time1=timeExtra;
}