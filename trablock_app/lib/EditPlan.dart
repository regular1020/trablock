import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trablock_app/Data.dart';
import 'package:trablock_app/SearchMap.dart';

class EditPlanRoute extends StatefulWidget {
  static final String routeName = '/edit';

  @override
  _EditPlanRouteState createState() => _EditPlanRouteState();
}

class _EditPlanRouteState extends State<EditPlanRoute> {
  //static String _destinationName = '';

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
          Expanded(
            child:  BuildDayPage(_travel, this),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
                                setState(() => _travel.candidateDestination.add(Destination(name: _destinationName)));
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
              Draggable(
                child: Card(child: Text('block'),),
                feedback: Card(child: Text('block'),),
                childWhenDragging: Container(),
                data: Destination(name: 'test'),
              ),
              Draggable(
                child: Card(child: Text('time'),),
                feedback: Card(child: Text('time'),),
                data: TimeTag.nullTag,
              ),
            ],
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
  final Travel travel;
  final State<EditPlanRoute> _routeState;
  BuildDayPage(this.travel, this._routeState);


  @override
  _BuildDayPageState createState() => _BuildDayPageState();
}

class _BuildDayPageState extends State<BuildDayPage> {
  static PageController _controller;
  static final int pageStartIndex = 0;
  static int _currentPage = 0;
  static final double _boxSize = 40;
  static final double _intervalSize = 40;
  static final double _intervalSizeWide = 80;
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _dayBoxIndicator(),
        Expanded(
          child: _setDayPage(),
        ),
      ],
    );
  }

  Widget _setDayPage(){
    return IndexedStack(
      index: pageStartIndex,
      children: <Widget>[
        PageView.builder(
          itemCount: widget.travel.days.length+1,
          physics: PageScrollPhysics(),
          onPageChanged: (int index){
            widget._routeState.setState(() {
              _currentPage = index;
            });
          },
          itemBuilder: (context, page) {
            if (page < widget.travel.days.length) {
              return Center(
                  child: BlockTower(destinationList: widget.travel.days[page], onEditMode: true,),
              );
            }
            else
              return Center(child: _newPage());
          },
        ),
      ],
    );
  }

  Widget _newPage() {
    return Container(
      child: Center(
        child: RaisedButton(
          child: Icon(Icons.add) ,//Text('', style: TextStyle(fontSize: 24))
          onPressed: (){
            setState(() {
              widget.travel.days.add([]);
            });
          },
        ),
      ),
    );
  }

  Widget _dayBoxIndicator(){
    List<Widget> res = [];
    for (int i = 0; i < widget.travel.days.length; i++){
      res.add(_makeInvert(index : i));
      res.add(
        Draggable(
          child: _makeBox(i),
          feedback: _makeBox(i),
          childWhenDragging: Container(),
          data: widget.travel.days[i],
          onDragStarted: () {
            setState(() {
              _onDragWidget = widget;
            });
          },
          onDragEnd: (details) {
            setState(() {
              _onDragWidget= null;
            });
          },
        ),
      );
    }
    res.add(_makeInvert(index: widget.travel.days.length));
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: res,
      )
    );
  }

  Widget _makeBox(int index){
    return Container(
      width: _boxSize,
      height: _boxSize,
      color: _currentPage == index ? Colors.red : Colors.grey,
      child: Text("${index+1}일차"),
    );
  }

  Widget _makeInvert({@required final int index}){
    return DragTarget(
      builder: (context, List<List<Destination>> candidateData, rejectedData){
        return Container(
          width: _onWillAcceptIndex == index ? _intervalSizeWide : _intervalSize,
          height: _boxSize,
          color: Colors.black,
        );
      },
      onWillAccept: (data){
        _onWillAcceptIndex = index;
        return true;
      },
      onLeave: (data){
        _onWillAcceptIndex = -1;
      },
      onAccept: (data){
        setState(() {
          int position = _onDragWidget.travel.days.indexOf(data);
          _onDragWidget.travel.days.remove(data);
          index > position
              ? widget.travel.days.insert(index - 1, data)
              : widget.travel.days.insert(index, data);

          _onWillAcceptIndex = -1;
        });
      },
    );
  }
}


class BlockTower extends StatefulWidget {
  // Destination, TimeTag 정보를 위젯으로 변환
  /* input:
   * List<Destination> _destinationList
     - required
     - 현재 계획중인 목적지 및 그 순서 정보 포함
   * bool onEditMode
     - optional(default: false)
     - 드래그 등을 통한 수정 가능 여부
   */
  final List<Destination> _destinationList;
  final bool _onEditMode;

  BlockTower({@required List<Destination> destinationList, onEditMode: false})
      : _destinationList = destinationList, _onEditMode = onEditMode;

  @override
  _BlockTowerState createState() => _BlockTowerState();
}

class _BlockTowerState extends State<BlockTower> {
  static const int widget_removeBar = 1;
  static const int opt_childWhenDragging = 1;

  static BlockTower _onDragWidget;
  static int _onWillAcceptIndex = -1;

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
                color: option & 1 != 0
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
    if(data == widget_removeBar) {
      return Row(
          children: <Widget>[
            Expanded(
                child: Container(
                  height: _onDragWidget != null ? 50 : 0,
                  decoration: BoxDecoration(gradient: LinearGradient(
                      colors: [_onWillAcceptIndex == -2 ? Colors.red : Colors.grey, Colors.transparent],
                      begin: FractionalOffset.bottomCenter,
                      end: FractionalOffset.topCenter
                  )),
                  child: Icon(Icons.delete, color: Colors.white,),
                )
            )
          ]
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    const double _intervalWidth = 220;
    const double _intervalHeight = 20;
    const double _intervalHeightWide = 40;

    List<Widget> result = [];

    for(int i=0; i<widget._destinationList.length; i++){
      Destination des = widget._destinationList[i];
      result.add(DragTarget(
        builder: (context, List<Destination> candidateData, rejectData){
          return Container(
            width: _intervalWidth,
            height: _onWillAcceptIndex == i
                ? _intervalHeightWide
                : _intervalHeight,
          );
        },
        onWillAccept: (data){
          _onWillAcceptIndex = i;
          return true;
        },
        onLeave: (data){
          _onWillAcceptIndex = -1;
        },
        onAccept: (data){
          if(data is Destination) {
            setState(() {
              if (_onDragWidget == null){
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
          } else if(data is TimeTag) {
            setState(() {
              if (_onDragWidget == null) {
                TextEditingController _controller = TextEditingController();
                // 새 태그를 추가하는 경우
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder:(BuildContext context) {
                      return AlertDialog(
                        content: Column(
                          children: <Widget>[
                            TextField(controller: _controller,)
                          ],
                        ),
                        actions: <Widget>[
                          FlatButton(onPressed: () {Navigator.pop(context, _controller.text);}, child: Text("ok")),
                          FlatButton(onPressed: () {Navigator.pop(context, "");}, child: Text("close")),
                        ],
                      );
                    }
                ).then((value) {setState(() {
                  if(value != "")
                    widget._destinationList[i].timeTag = TimeTag(time: value);
                });});
              }
              else {
                for(int j=0; j<_onDragWidget._destinationList.length; j++)
                  if(_onDragWidget._destinationList[j].timeTag == data)
                    _onDragWidget._destinationList[j].timeTag = TimeTag.nullTag;
                widget._destinationList[i].timeTag = TimeTag.copy(data);
              }
              _onWillAcceptIndex = -1;
            });
          }
        },
      ));  // interval
      result.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Draggable(
            child: getWidget(des),
            feedback: getWidget(des),
            childWhenDragging: getWidget(des, option: opt_childWhenDragging),
            data: des,
            onDragStarted: () {
              setState(() {
                _onDragWidget = widget;
              });
            },
            onDragEnd: (details) {
              setState(() {
                _onDragWidget= null;
              });
            },
          ),  // Destination
          Draggable(  // TimeTag
            child: getWidget(des.timeTag),
            feedback: getWidget(des.timeTag),
            childWhenDragging: getWidget(des.timeTag, option: opt_childWhenDragging),
            data: des.timeTag,
            onDragStarted: () {
              setState(() {
                _onDragWidget = widget;
              });
            },
            onDragEnd: (details) {
              setState(() {
                _onDragWidget= null;
              });
            },
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
            return getWidget(widget_removeBar);
          },
          onWillAccept: (data) {
            _onWillAcceptIndex = -2;
            return true;
          },
          onLeave: (data) {
            _onWillAcceptIndex = -1;
          },
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