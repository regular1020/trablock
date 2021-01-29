import 'package:flutter/material.dart';
import 'package:trablock_app/Data.dart';

class EditPlanRoute extends StatefulWidget {
  static final String routeName = '/edit';

  @override
  _EditPlanRouteState createState() => _EditPlanRouteState();
}

class _EditPlanRouteState extends State<EditPlanRoute> {
  @override
  Widget build(BuildContext context) {
    Travel _travel = ModalRoute.of(context).settings.arguments;

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
              Draggable(
                child: Card(child: Text('block'),),
                feedback: Card(child: Text('block'),),
                childWhenDragging: Container(),
                data: Destination('name') as Insertable,
              ),
              Draggable(
                child: Card(child: Text('time'),),
                feedback: Card(child: Text('time'),),
                data: TimeTag.nullTag as Insertable,
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
  static final double _blockWidth = 200;
  static final double _blockHeight = 60;
  static final double _tagWidth = 60;
  static final double _tagHeight = 30;
  static final double _intervalHeight = 20;
  static final double _intervalHeightWide = 40;

  static BlockTower _onDragWidget;

  int _onWillAcceptIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget._onEditMode)
      return _buildEditBlockTower();
    return _buildBlockTower();
  }

  Widget _buildBlockTower() {
    // 상호작용 불가능한 BlockTower
    List<Widget> result = [];

    for(int i=0; i<widget._destinationList.length; i++) {
      result.add(_makeBlock(index: i));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: result,
    );
  }
  Widget _buildEditBlockTower(){
    // 드래그 및 수정 가능한 BlockTower
    List<Widget> result = [];

    for(int i=0; i<widget._destinationList.length; i++){
      result.add(_makeInterval(index: i));
      result.add(Draggable(
        child: _makeBlock(index: i),
        feedback: _makeBlock(index: i),
        childWhenDragging: Container(),
        data: widget._destinationList[i] as Insertable,
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
      ));
    }
    result.add(_makeInterval(index: widget._destinationList.length));

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: result
        ),
        _makeRemoveBar(),
      ],
     );
  }

  Widget _makeBlock({@required final int index}){
    // 블럭 Widget
    Destination des = widget._destinationList[index];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: _blockWidth,
          height: _blockHeight,
          color: Colors.orange,
          child: Text(des.name),
        ),
        Container(
          width: _tagWidth,
          height: _tagHeight,
          color: widget._destinationList[index].timeTag == TimeTag.nullTag
              ? null
              : Colors.blue,
          child: Text(
              widget._destinationList[index].timeTag == TimeTag.nullTag
                  ? ''
                  : widget._destinationList[index].timeTag.time0),
        )
      ],
    );
  }
  Widget _makeInterval({@required final int index}){
    // 블럭 사이 공간에 넣을 DragTarget
    return DragTarget(
      builder: (context, List<Insertable> candidateData, rejectData){
        return Container(
          width: _blockWidth + _tagWidth,
          height: _onWillAcceptIndex == index
              ? _intervalHeightWide
              : _intervalHeight,
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
        switch (data.runtimeType) {
          case Destination:
            setState(() {
              if (_onDragWidget == null){
                // 새 블럭을 추가하는 경우
                widget._destinationList.insert(index, data);
              } else if (_onDragWidget == widget) {
                // 도달한 부분 일자와 출발한 부분 일자가 동일한 경우
                int position = _onDragWidget._destinationList.indexOf(data);
                _onDragWidget._destinationList.removeAt(position);
                index > position
                  ? widget._destinationList.insert(index - 1, data)
                  : widget._destinationList.insert(index, data);
              } else {
                _onDragWidget._destinationList.remove(data);
                widget._destinationList.insert(index, data);
              }
              _onWillAcceptIndex = -1;
            });
            break;

          case TimeTag:
            setState(() {
              if (data == TimeTag.nullTag) {
                // 새 태그를 추가하는 경우
                String timeText = "11:00";
                widget._destinationList[index].timeTag = TimeTag(time: timeText);
              }
              _onWillAcceptIndex = -1;
            });
            break;
        }
      },
    );
  }

  static Widget _makeRemoveBar(){
    return DragTarget(
      builder: (context, List<Insertable> candidateData, rejectedData){
        return Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                    height: _onDragWidget != null ? 50 : 0,
                    color: Colors.red,
                  )
              )
            ]
        );
      },
      onAccept: (data) {
        switch (data.runtimeType) {
          case Destination:
            _onDragWidget._destinationList.remove(data);
            break;

          case TimeTag:
            break;
        }
      },
    );
  }
}
