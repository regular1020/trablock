import 'package:flutter/material.dart';
import 'package:trablock_app/Data.dart';
import 'package:trablock_app/EditPlan.dart';

import 'ShowMap.dart';

// 메인화면에서 각 계획 클릭시 나타날 화면. 작성된 계획을 보기 편하게 보여줘야 할듯

class ShowPlanRoute extends StatefulWidget {
  static final String routeName = '/show';

  @override
  _ShowPlanRouteState createState() => _ShowPlanRouteState();
}

class _ShowPlanRouteState extends State<ShowPlanRoute> {
  PageController controller;
  int pageInitIndex = 0;
  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Travel _travel = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(  // 계획 수정버튼 등 필요
        title: Text(_travel.title),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.edit),
            tooltip : '여행 일정을 수정하기',
            onPressed: (){
              Navigator.pushNamed(
                  context,
                  EditPlanRoute.routeName,
                  arguments: _travel,
              );
            },
          )
        ],
      ),
      body: IndexedStack(
        index : pageInitIndex,
        children: <Widget>[
          PageView.builder(
            itemBuilder: (context, page) {
              return Center(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text((page+1).toString() + "일차"),
                          IconButton(
                            icon: Icon(Icons.map_outlined),
                            onPressed: (){
                              setState(() {
                                Navigator.pushNamed(
                                  context,
                                  ShowMap.routeName,
                                  arguments: _travel.days[page],
                                );
                              });
                            },
                          )
                        ],
                      ),
                      Expanded(
                        child: BuildShowBlockTower(_travel, page),
                      )
                    ]
                  ),
                ),
              );
            },
            itemCount: _travel.days.length,
            controller: controller,
          ),
        ],
      ),
    );
  }
}

class BuildShowBlockTower extends StatelessWidget {
  Travel _travel;
  int day;
  BuildShowBlockTower(this._travel, this.day);

  @override
  Widget build(BuildContext context) {
    List<Widget> _tower = [];

    for (int i = 0; i < _travel.days[day].length-1; i++){
      _tower.add(
        Container(
          height: MediaQuery.of(context).size.height*0.08,
          width: MediaQuery.of(context).size.width*0.6,
          child: Center(
            child: Text(
              _travel.days[day][i].name,
              style: TextStyle(fontSize: 20),
            ),
          ),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.lightGreenAccent
          ),
        )
      );
      _tower.add(
        Padding(
          padding: EdgeInsets.all(20),
          child: Icon(Icons.arrow_downward, size: 40,),
        )
      );
    }
    _tower.add(
        Container(
          height: MediaQuery.of(context).size.height*0.08,
          width: MediaQuery.of(context).size.width*0.6,
          child: Center(
            child: Text(
              _travel.days[day][_travel.days[day].length-1].name,
              style: TextStyle(fontSize: 20),
            ),
          ),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.lightGreenAccent
          ),
        )
    );

    return ListView(
      padding: EdgeInsets.only(left: 50, right: 50),
      children: _tower,
    );
  }
}
