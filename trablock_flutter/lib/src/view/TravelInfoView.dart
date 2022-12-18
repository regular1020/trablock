import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/model/PlaceModel.dart';
import 'package:trablock_flutter/src/model/TravelModel.dart';
import 'package:trablock_flutter/src/provider/TravelProvider.dart';

class TravelInfoView extends StatefulWidget {
  const TravelInfoView({Key? key}) : super(key: key);

  @override
  State<TravelInfoView> createState() => _TravelInfoViewState();
}

class _TravelInfoViewState extends State<TravelInfoView> {

  late Travel _travel;
  List<Place> currentDatePlaces = [];
  List<Place> unassignedPlaces = [];
  List<List<Place>> assignedPlaces = [];

  @override
  void initState() {
    _travel = Provider.of<TravelProvider>(context, listen: false).selectedTravel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    unassignedPlaces = [];
    assignedPlaces = [];
    for (int i = 0; i < _travel.days; i++) {
      assignedPlaces.add([]);
    }
    for (Place place in _travel.places) {
      if (place.dateOfVisit == -1) {
        unassignedPlaces.add(place);
      } else {
        assignedPlaces[place.dateOfVisit-1].add(place);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("${_travel.destination}여행"),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _travel.places.forEach((element) {
              Provider.of<TravelProvider>(context, listen: false).saveChangeToFireStore(element);
            });
          },
          child: const Icon(Icons.save),
      ),
      body: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width*0.7,
            child: PageView(
              pageSnapping: true,
              controller: pageController,
                children: List<int>.generate(_travel.days, (dayIndex) => dayIndex+1).map((dayI) {
                  return Builder(
                    builder: (BuildContext context) {
                      print(dayI);
                      assignedPlaces[dayI-1].sort((a,b) => a.index.compareTo(b.index));
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "$dayI일차",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ReorderableListView(
                              onReorder: (int oldIndex, int newIndex) {
                                setState(() {
                                  if (oldIndex < newIndex) {
                                    newIndex -= 1;
                                    for (int i = oldIndex+1; i <= newIndex; i++) {
                                      assignedPlaces[dayI-1][i].index--;
                                    }
                                    assignedPlaces[dayI-1][oldIndex].index = newIndex;
                                  }
                                  else {
                                    for (int i = newIndex; i < oldIndex; i++) {
                                      assignedPlaces[dayI-1][i].index++;
                                    }
                                    assignedPlaces[dayI-1][oldIndex].index = newIndex;
                                  }
                                  final Place place = assignedPlaces[dayI-1].removeAt(oldIndex);
                                  assignedPlaces[dayI-1].insert(newIndex, place);
                                });
                              },
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              children: <Widget>[
                                if (assignedPlaces[dayI-1].length == 0)
                                  Container(
                                    key : Key('0'),
                                    child: DragTarget<Place>(
                                      builder: (context, candidatePlace, rejectedPlaces) {
                                        return Container(
                                          height: MediaQuery.of(context).size.height*0.8,
                                        );
                                      },
                                      onAccept: (place) {
                                        setState(() {
                                          place.dateOfVisit = dayI;
                                          place.index = 0;
                                          assignedPlaces[dayI-1].add(place);
                                        });
                                      },
                                    ),
                                  )
                                else
                                for (int placeIndex = 0; placeIndex < assignedPlaces[dayI-1].length; placeIndex++)
                                  SizedBox(
                                    key : Key('$placeIndex'),
                                    height : assignedPlaces[dayI-1][placeIndex].hour*120.0+assignedPlaces[dayI-1][placeIndex].minute*2.0,
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.blueGrey.withOpacity(0.8),
                                                borderRadius: BorderRadius.circular(15)
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Center(
                                                          child: Text(
                                                            assignedPlaces[dayI-1][placeIndex].name,
                                                            style: const TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 20),
                                                          )
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              for (int i = placeIndex+1; i < assignedPlaces[dayI-1].length; i++) {
                                                                assignedPlaces[dayI-1][i].index--;
                                                              }
                                                              assignedPlaces[dayI-1][placeIndex].dateOfVisit = -1;
                                                              assignedPlaces[dayI-1][placeIndex].index = -1;
                                                              assignedPlaces[dayI-1].removeAt(placeIndex);
                                                            });
                                                          },
                                                          child: const Text(
                                                            "삭제",
                                                            style: TextStyle(
                                                                color: Colors.white
                                                            ),
                                                          )
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "${assignedPlaces[dayI-1][placeIndex].hour}시간 ${assignedPlaces[dayI-1][placeIndex].minute}분",
                                                    style: const TextStyle(
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ),
                                        DragTarget<Place>(
                                          builder: (context, candidatePlace, rejectedPlace) {
                                            return Container(
                                              height: (assignedPlaces[dayI-1][placeIndex].hour*120.0+assignedPlaces[dayI-1][placeIndex].minute*2.0)/2,
                                            );
                                          },
                                          onAccept: (place) {
                                            setState(() {
                                              place.dateOfVisit = dayI;
                                              place.index = placeIndex;
                                              for (int i = placeIndex; i < assignedPlaces[dayI-1].length; i++) {
                                                assignedPlaces[dayI-1][i].index++;
                                              }
                                              assignedPlaces[dayI-1].insert(placeIndex, place);
                                              unassignedPlaces.remove(place);
                                            });
                                          },
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: (assignedPlaces[dayI-1][placeIndex].hour*120.0+assignedPlaces[dayI-1][placeIndex].minute*2.0)/2,
                                            ),
                                            DragTarget<Place>(
                                              builder: (context, candidatePlace, rejectedPlace) {
                                                return Container(
                                                  height: (assignedPlaces[dayI-1][placeIndex].hour*120.0+assignedPlaces[dayI-1][placeIndex].minute*2.0)/2,
                                                );
                                              },
                                              onAccept: (place) {
                                                setState(() {
                                                  place.dateOfVisit = dayI;
                                                  place.index = placeIndex+1;
                                                  for (int i = placeIndex+1; i < assignedPlaces[dayI-1].length; i++) {
                                                    assignedPlaces[dayI-1][i].index++;
                                                  }
                                                  assignedPlaces[dayI-1].insert(placeIndex+1, place);
                                                  unassignedPlaces.remove(place);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  );
                }).toList(),
            )

          ),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.3,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: Text("잔여일정", style: TextStyle(fontSize: 20),)),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: unassignedPlaces.length+1,
                    itemBuilder: (context, index) {
                      if (index == unassignedPlaces.length) {
                        return TextButton(
                          onPressed: () {

                          },
                          child: const Text("추가")
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: LongPressDraggable<Place>(
                            data: unassignedPlaces[index],
                            feedback: Container(
                              height: MediaQuery.of(context).size.width*0.25,
                              width: MediaQuery.of(context).size.width*0.25,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(child: Text(unassignedPlaces[index].name, style: const TextStyle(color: Colors.white, fontSize: 20),)),
                            ),
                            child: Container(
                              height: MediaQuery.of(context).size.width*0.25,
                              width: MediaQuery.of(context).size.width*0.25,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(child: Text(unassignedPlaces[index].name, style: const TextStyle(color: Colors.white, fontSize: 20),)),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
