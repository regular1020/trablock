import 'package:flutter/material.dart';
import 'package:trablock_app/Data.dart';

class _UserInterface {
  static const int opt_childWhenDragging = 1;

  static Widget getWidget(data, {option = 0}) {
    if(data is Destination) {
      double _widgetWidth = 200, _widgetHeight = 60;
      return Container(
          width: _widgetWidth,
          height: _widgetHeight,
          color: option & 1 != 0
              ? Color.fromRGBO(
              data.blockColor[0], data.blockColor[1], data.blockColor[2], 0.3)
              : Color.fromRGBO(
              data.blockColor[0], data.blockColor[1], data.blockColor[2], 1),
          child: Center(child: Text(
            data.name,
            style: TextStyle(
                fontSize: 20,
                color: option & opt_childWhenDragging != 0
                    ? Colors.grey
                    : Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal
            ),
          ))
      );
    }
    else if(data is TimeTag) {
      double _widgetWidth = 60, _widgetHeight = 30;
      if(data == TimeTag.nullTag)
        return Container(width: _widgetWidth, height: 0,);
      return Container(
        width: _widgetWidth,
        height: _widgetHeight,
        color: option | opt_childWhenDragging
            ? Colors.cyanAccent : Colors.blue,
        child: Text(
          data.time0,
          style: TextStyle(
              fontSize: 15,
              color: option | opt_childWhenDragging
                  ? Colors.grey
                  : Colors.black,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal
          ),
        ),
      );
    }
    return Container();
  }

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

  @override
  Widget build(BuildContext context) {
    Travel _travel = ModalRoute.of(context).settings.arguments;
    String _destinationName = '';

    return Scaffold(
      appBar: AppBar(
        title: Text('일정수정'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(child:  BuildDayPage(_travel, this)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                padding: EdgeInsets.only(top: 20, bottom: 20,),
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
                            // ignore: deprecated_member_use
                            FlatButton(
                              child: Text("확인"),
                              onPressed: (){
                                Navigator.pop(context);
                                setState(() => _travel.candidateDestination.add(Destination(name: _destinationName)));
                              },
                            ),
                            // ignore: deprecated_member_use
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
              BuildSideBoxList(_travel),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20,),
                child: Draggable(
                  child: Card(child: Text('time'),),
                  feedback: Card(child: Text('time'),),
                  data: TimeTag.nullTag,
                ),
              ),
              Expanded(child: Container(),),
            ],
          ),
        ],
      ),
    );
  }
}

class BuildSideBoxList extends StatelessWidget {
  Travel travel;
  BuildSideBoxList(this.travel);
  List<Widget> _sideBoxes = [];

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < travel.candidateDestination.length; i++){
      _sideBoxes.add(
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20,),
          child: Draggable(
            child: Card(child: Text(travel.candidateDestination[i].name),),
            feedback: Card(child: Text(travel.candidateDestination[i].name),),
            childWhenDragging: Container(),
            data: Destination(name: travel.candidateDestination[i].name),
          ),
        ),
      );
    }

    return Column(
      children: _sideBoxes,
    );
  }
}

class BuildDayPage extends StatefulWidget {
  //여행날짜와 여행지 리스트를 입력받으면 그에 해당하는 viewpage를 생성하는 클래스
  //input : List<List<Destination>> 날짜별 여행지 목록
  //output : 좌우로 넘길 수 있는 ViewPage 위젯
  final Travel travel;
  final State<EditPlanRoute> _routeState;
  BuildDayPage(this.travel, this._routeState);

  @override
  _BuildDayPageState createState() => _BuildDayPageState();
}

class _BuildDayPageState extends State<BuildDayPage> {
  static PageController _controller;
  static const int pageStartIndex = 0;
  static int _currentPage = 0;

  static int _onWillAcceptIndex = -1;

  static BuildDayPage _onDragWidget;

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
    for (int i = 0; i <= widget.travel.days.length; i++) {
      res.add(DragTarget(
        builder: (context, List<List<Destination>> candidateData, rejectedData){
          return Container(
            width: _onWillAcceptIndex == i ? 40 : 20,
            height: 30,
          );
        },
        onWillAccept: (data){
          _onWillAcceptIndex = i;
          return true;
        },
        onLeave: (data) => _onWillAcceptIndex = -1,
        onAccept: (data) => setState(() {
          int position = _onDragWidget.travel.days.indexOf(data);
          _onDragWidget.travel.days.remove(data);
          i > position
              ? widget.travel.days.insert(i - 1, data)
              : widget.travel.days.insert(i, data);
          _onWillAcceptIndex = -1;
          if(_currentPage == position)
            i > position
              ? _controller.jumpToPage(i-1)
              : _controller.jumpToPage(i);
        }),
      ));  // invert
      if(i == widget.travel.days.length) {
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
        data: widget.travel.days[i],
        onDragStarted: () => setState(() => _onDragWidget = widget),
        onDragEnd: (details) => setState(() => _onDragWidget= null),
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
              itemCount: widget.travel.days.length+1,
              physics: const PageScrollPhysics(),
              onPageChanged: (int index) => widget._routeState.setState(() => _currentPage = index),
              itemBuilder: (context, page) =>
                page < widget.travel.days.length
                  ? BlockTower(widget.travel.days[page])
                  // ignore: deprecated_member_use
                  : Center(child: RaisedButton(
                    child: Icon(Icons.add) ,//Text('', style: TextStyle(fontSize: 24))
                    onPressed: () => setState(() => widget.travel.days.add([])),
                  )),
            ),
          ],
        )),  // PageView
      ],
    );
  }
}

class BlockTower extends StatefulWidget {
  // Destination, TimeTag 정보를 위젯으로 변환
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
    const double _intervalWidth = 220;
    const double _intervalHeight = 20;
    const double _intervalHeightWide = 40;

    List<Widget> result = [];

    for(int i=0; i<=widget._destinationList.length; i++){
      result.add(DragTarget(
        builder: (context, List<Destination> candidateData, rejectData){
          return Container(
            width: _intervalWidth,
            height: _onWillAcceptIndex == i
                ? _intervalHeightWide
                : _intervalHeight,
          );
        },
        onWillAccept: (data) {
          _onWillAcceptIndex = i;
          return true;
        },
        onLeave: (data) => _onWillAcceptIndex = -1,
        onAccept: (data){
          setState(() {
            if (_onDragWidget == null) {
              // 새 블럭을 추가하는 경우
              widget._destinationList.insert(i, data);
            } else if (_onDragWidget == widget) {
              // 도달한 부분 일자와 출발한 부분 일자가 동일한 경우
              int position = _onDragWidget._destinationList.indexOf(data);
              _onDragWidget._destinationList.removeAt(position);
              i > position
                ? widget._destinationList.insert(i - 1, data)
                : widget._destinationList.insert(i, data);
            } else {
              _onDragWidget._destinationList.remove(data);
              widget._destinationList.insert(i, data);
            }
            _onWillAcceptIndex = -1;
          });
        },
      ));  // interval
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
              child: _UserInterface.getWidget(des),
              feedback: _UserInterface.getWidget(des),
              childWhenDragging: _UserInterface.getWidget(des, option: _UserInterface.opt_childWhenDragging),
              data: des,
              onDragStarted: () => setState(() => _onDragWidget = widget),
              onDragEnd: (details) => setState(() => _onDragWidget= null),
            ),
            onTap: () => Navigator.pushNamed(context, TempRoute.routeName),
          ),  // Destination
          Draggable(  // TimeTag
            child: _UserInterface.getWidget(des.timeTag),
            feedback: _UserInterface.getWidget(des.timeTag),
            childWhenDragging: _UserInterface.getWidget(des.timeTag, option: _UserInterface.opt_childWhenDragging),
            data: des.timeTag,
            onDragStarted: () => setState(() => _onDragWidget = widget),
            onDragEnd: (details) => setState(() => _onDragWidget= null),
          ),  // TimeTag
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
            if(data is Destination) {
              _onDragWidget._destinationList.remove(data);
            }
            else if (data is TimeTag) {
              for (int i = 0; i < _onDragWidget._destinationList.length; i++)
                if (_onDragWidget._destinationList[i].timeTag == data) {
                  _onDragWidget._destinationList[i].timeTag = TimeTag.nullTag;
                  break;
                }
            }
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
