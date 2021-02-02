import 'package:flutter/material.dart';
import 'package:trablock_app/Data.dart';
import 'package:trablock_app/EditPlan.dart';
import 'package:trablock_app/SearchMap.dart';
import 'package:trablock_app/ShowMap.dart';
import 'package:trablock_app/showPlan.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: MainRoute.routeName,
      routes: {
        MainRoute.routeName: (context) => MainRoute(),
        ShowPlanRoute.routeName: (context) => ShowPlanRoute(),
        EditPlanRoute.routeName: (context) => EditPlanRoute(),
        ShowMap.routeName: (context) => ShowMap(),
        SearchMap.routeName: (context) => SearchMap(),
      },
    );
  }
}

// MyHomePage 대신 다른 이름 필요성 느낌
class MainRoute extends StatefulWidget {
  static final String routeName = '/';

  @override
  _MainRouteState createState() => _MainRouteState();
}

class _MainRouteState extends State<MainRoute> {
  String _travelName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('관리메뉴'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('일정 제거'),
              onTap : () {
                // Upadte the state of the app
                // 제거할 일정 선택하는 기능
                Navigator.pop(context);
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeleteTravel(),
                    ),
                  );
                });
              },
            ),
            ListTile(
              title: Text('설정'),
              onTap: () {
                // Upadte the state of the app
                // 기타 설정창으로 넘어가는 기능
                Navigator.pop(context);
              },
            ),

          ],
        ),
      ),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('widget.title'),
      ),
      body: TravelListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text('여행이름입력'),
                content: TextField(
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(hintText: '입력해 주세요'),
                    onChanged: (String str) {
                      setState(() => _travelName = str);
                    },
                ),//입력칸 추가완료
                actions: <Widget>[
                  FlatButton(
                    child: Text("확인"),
                    onPressed: (){
                      Navigator.pop(context);
                      setState(() {
                        myTravelList.add(Travel(_travelName));
                      });
                    },
                  ),
                  FlatButton(
                    child: Text(
                      "취소",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            }
          );
        },
        tooltip: '새 여행 시작',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class TravelTile extends StatelessWidget{
  // 리스트뷰에 보여질 각각의 타일들
  TravelTile(this._travel);

  final Travel _travel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_travel.title),
      onTap: (){  // 클릭 시 해당하는 여행계획 화면으로 이동
        Navigator.pushNamed(
            context,
            ShowPlanRoute.routeName,
            arguments: _travel
        );
      },
    );
  }
}

class TravelListView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: myTravelList.length,
      itemBuilder: (BuildContext context, int index){
        return TravelTile(myTravelList[index]);
      },
    );
  }
}

class DeleteTravel extends StatefulWidget {
  @override
  _DeleteTravelState createState() => _DeleteTravelState();
}

class _DeleteTravelState extends State<DeleteTravel> {
  List<Travel> deleteList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('일정 삭제'),
      ),
      body: Container(
        padding: new EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Expanded(
              child: ListView.builder(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                itemCount: myTravelList.length,
                itemBuilder: (BuildContext context, int index){
                  return selectableTravelList(myTravelList[index]);
                },
              ),
            ),
            RaisedButton(
              child: Text('제거'),
              onPressed: (){
                setState(() {
                  for (Travel t in deleteList){
                    myTravelList.remove(t);
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainRoute(),
                    ),
                  );
                });
              }
            )
          ],
        )
      )
    );
  }

  ListTile selectableTravelList(Travel _travel){
    return ListTile(
      title: new Row(
        children: <Widget>[
          new Expanded(child: Text(_travel.title)),
          new Checkbox(
              value: _travel.isSelected,
              onChanged: (bool value) {
                setState(() {
                  _travel.isSelected = value;
                  if (_travel.isSelected == true){
                    deleteList.add(_travel);
                  }
                  else {
                    deleteList.remove(_travel);
                  }
                });
              }
          )
        ],
      ),
    );
  }
}