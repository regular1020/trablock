import 'package:flutter/material.dart';
import 'package:trablock_app/Data.dart';

Travel _currentTravel;
State _routeState;

class _UserInterface {
  /* 위젯 중 순수 디자인 영역에 해당하는 위젯을 리턴하는 함수의 모음
   * 값에 따라 다른 형태의 위젯을 리턴하는 것까지 해당 클래스에 포함
   * Button, Drag 관련 위젯 등 이벤트 관련 코드가 포함되는 경우 해당 클래스에 작성하지 않음
   */
  static const int opt_childWhenDragging = 1;
  static const int opt_feedback = 2;

  static Widget destinationWidget(Destination data, {option = 0}) => Container(
    width: 200,
    height: 60,
    color: option & 1 != 0
      ? Color.fromRGBO(data.blockColor[0], data.blockColor[1], data.blockColor[2], 0.3)
      : Color.fromRGBO(data.blockColor[0], data.blockColor[1], data.blockColor[2], 1),
    child: Row(
      mainAxisAlignment: data.planType != Destination.type_none
        ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: data.planType != Destination.type_none ? 40 : 0,
          child: Icon(data.planType, size: 20, color: option & opt_childWhenDragging != 0 ? Colors.grey : Colors.black),
        ),
        Text(
          data.name,
          style: TextStyle(
            fontSize: 20,
            color: option & opt_childWhenDragging != 0 ? Colors.grey : Colors.black,
            decoration: TextDecoration.none,
            fontWeight: FontWeight.normal
          ),
        )
      ]
    )
  );

  static Widget destinationInterval(int index) => Container(
    width: 200,
    height: _BlockTowerState._onWillAcceptIndex == index ? 40 : 20,
    color: _BlockTowerState._onWillAcceptIndex == index ? Colors.pinkAccent : null,
  );

  static Widget candidateWidget(Destination data, {option = 0}) => Container(
    height: option & opt_childWhenDragging != 0 ?  0 : 20,
    color: Color.fromRGBO(data.blockColor[0], data.blockColor[1], data.blockColor[2], 1),
    margin: const EdgeInsets.only(top: 30),
    child: Text(
      data.name,
      style: TextStyle(
        color: Colors.black,
        fontSize: 15,
        decoration: TextDecoration.none,
        fontWeight: FontWeight.normal
      ),
    )
  );

  static Widget _indicatorBox(int index) => Container(
    width: 30, height: 30,
    child: Icon(
      Icons.circle,
      size: 20,
      color: _BuildDayPageState._currentPage == index ? Colors.black : Colors.grey,
    )
  );

  static Widget removeBar() => Row(
      children: <Widget>[
        Expanded(
            child: Container(
              height: _BlockTowerState._onDragWidget != null ? 50 : 0,
              decoration: BoxDecoration(gradient: LinearGradient(
                  colors: [_BlockTowerState._onWillAcceptIndex == -2 ? Colors.red : Colors.grey, Colors.transparent],
                  begin: FractionalOffset.bottomCenter,
                  end: FractionalOffset.topCenter
              )),
              child: Icon(Icons.delete, color: Colors.white,),
            )
        )
      ]
  );
}

class EditPlanRoute extends StatefulWidget {
  static final String routeName = '/edit';

  @override
  _EditPlanRouteState createState() => _EditPlanRouteState();
}

class _EditPlanRouteState extends State<EditPlanRoute> {
  TextEditingController controller = TextEditingController();
  static bool _onSideBar = false;

  @override
  Widget build(BuildContext context) {
    _routeState = this;
    _currentTravel = ModalRoute.of(context).settings.arguments;
    String _destinationName = '';

    List<Widget> candidateWidgetList = [];
    for(int i=0; i<_currentTravel.candidateDestination.length; i++) {
      Destination data = _currentTravel.candidateDestination[i];
      candidateWidgetList.add(Draggable(
        child: _UserInterface.candidateWidget(data),
        feedback: _UserInterface.candidateWidget(data),
        childWhenDragging: _UserInterface.candidateWidget(data, option: _UserInterface.opt_childWhenDragging),
        data: data,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('일정수정'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(child:  Stack(
            children: [
              BuildDayPage(),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(_onSideBar ? Icons.keyboard_arrow_right : Icons.keyboard_arrow_left),
                  onPressed: () => setState(() => _onSideBar = !_onSideBar),
                )
              )
            ],
          )),
          Container(
            width: _onSideBar ? 100 : 0,
            color: Colors.blueGrey,
            child: Column(children: <Widget>[
              IconButton(
                    icon: Icon(Icons.add),
                    onPressed: (){
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: Text('여행지 입력'),
                              content: TextField(
                                style: TextStyle(fontSize: 20, color: Colors.black),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(hintText: '입력해 주세요'),
                                onChanged: (String str) {
                                  setState(() {
                                    _destinationName = str;
                                  });
                                },
                              ),//입력칸 추가완료
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("확인"),
                                  onPressed: (){
                                    Navigator.pop(context);
                                    setState(() => _currentTravel.candidateDestination.add(Destination(_destinationName)));
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
                  ),
              Expanded(child: SingleChildScrollView(child: Column(children: candidateWidgetList)))
            ]),
          ),
        ],
      ),

    );
  }
}

class BuildDayPage extends StatefulWidget {
  //여행날짜와 여행지 리스트를 입력받으면 그에 해당하는 viewpage를 생성하는 클래스
  //input : List<List<Destination>> 날짜별 여행지 목록
  //output : 좌우로 넘길 수 있는 ViewPage 위젯

  @override
  _BuildDayPageState createState() => _BuildDayPageState();
}

class _BuildDayPageState extends State<BuildDayPage> {
  static PageController _controller;
  static const int pageStartIndex = 0;
  static int _currentPage = 0;
  static int _onWillAcceptIndex = -1;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> res = [];
    for (int i = 0; i <= _currentTravel.days.length; i++) {
      res.add(DragTarget(
        builder: (context, List<List<Destination>> candidateData, rejectedData) => Container(
          width: _onWillAcceptIndex == i ? 40 : 20,
          height: 30,
        ),
        onWillAccept: (data) {_onWillAcceptIndex = i; return true;},
        onLeave: (data) => _onWillAcceptIndex = -1,
        onAccept: (data) => setState(() {
          _currentTravel.days.insert(i, List<Destination>.from(data));
          _currentTravel.days.remove(data);
          _onWillAcceptIndex = -1;
        }),
      ));  // indicator interval
      if(i == _currentTravel.days.length) {
        res.add(InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: _UserInterface._indicatorBox(i),
          onTap: () => _controller.animateToPage(i, duration: const Duration(milliseconds: 100), curve: Curves.fastOutSlowIn),
        ));  // new page indicator
        continue;
      }
      res.add(Draggable(
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: _UserInterface._indicatorBox(i),
          onTap: () => _controller.animateToPage(i, duration: const Duration(milliseconds: 100), curve: Curves.fastOutSlowIn),
        ),
        feedback: _UserInterface._indicatorBox(i),
        childWhenDragging: Container(),
        data: _currentTravel.days[i],
      ));  // each page indicator
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: res,
            )
        ),  // indicator
        Expanded(child: IndexedStack(
          index: pageStartIndex,
          children: <Widget>[
            PageView.builder(
              controller: _controller,
              itemCount: _currentTravel.days.length+1,
              physics: const PageScrollPhysics(),
              onPageChanged: (int index) => _routeState.setState(() => _currentPage = index),
              itemBuilder: (context, page) =>
                page < _currentTravel.days.length
                  ? BlockTower(_currentTravel.days[page])
                  : Center(child: RaisedButton(
                    child: Icon(Icons.add) ,//Text('', style: TextStyle(fontSize: 24))
                    onPressed: () => setState(() => _currentTravel.days.add([])),
                  )),
            ),
          ],
        )),  // PageView
      ],
    );
  }
}

class BlockTower extends StatefulWidget {
  /* input:
   * List<Destination> _destinationList
     - required
     - 현재 계획중인 목적지 및 그 순서 정보 포함
   */
  final List<Destination> _destinationList;

  BlockTower(this._destinationList);

  @override
  _BlockTowerState createState() => _BlockTowerState();
}

class _BlockTowerState extends State<BlockTower> {
  static BlockTower _onDragWidget;
  static int _onWillAcceptIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<Widget> result = [];

    for(int i=0; i<=widget._destinationList.length; i++){
      result.add(DragTarget(
        builder: (context, List<Destination> candidateData, rejectData) => _UserInterface.destinationInterval(i),
        onWillAccept: (data) {
          _onWillAcceptIndex = i;
          return true;
        },
        onLeave: (data) => _onWillAcceptIndex = -1,
        onAccept: (data) => setState(() {
          if (_onDragWidget == null) {
            // 새 블럭을 추가하는 경우
            _routeState.setState(() => myTravelList[0].candidateDestination.remove(data));
            widget._destinationList.insert(i, data);
          } else  {
            widget._destinationList.insert(i, Destination.copy(data));
            _onDragWidget._destinationList.remove(data);
          }
          _onWillAcceptIndex = -1;
        }),
      ));  // destination interval
      if(i >= widget._destinationList.length) continue;
      Destination des = widget._destinationList[i];
      result.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Draggable(
              child: _UserInterface.destinationWidget(des),
              feedback: _UserInterface.destinationWidget(des),
              childWhenDragging: _UserInterface.destinationWidget(des, option: _UserInterface.opt_childWhenDragging),
              data: des,
              onDragStarted: () => setState(() => _onDragWidget = widget),
              onDragEnd: (details) => setState(() => _onDragWidget= null),
            ),
            onTap: () => Navigator.pushNamed(context, TempRoute.routeName),
          ),  // Destination
        ],
      ));  // each tile
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(),
        Positioned.fill(child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(parent: const AlwaysScrollableScrollPhysics()),
          child: Column(children: result),
        )),
        DragTarget(
          builder: (context, List<Destination> candidateData, rejectedData){
            return _UserInterface.removeBar();
          },
          onWillAccept: (data) {
            _onWillAcceptIndex = -2;
            return true;
          },
          onLeave: (data) => _onWillAcceptIndex = -1,
          onAccept: (data) {
            _routeState.setState(() => myTravelList[0].candidateDestination.add(data));
            _onDragWidget._destinationList.remove(data);
          },
        ),  // Remove_bar
      ],
     );
  }
}

class TempRoute extends StatelessWidget {
  static const routeName = "/tmp";
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar());
  }
}
