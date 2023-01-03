import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reorderables/reorderables.dart';
import 'package:trablock_flutter/src/model/PlaceModel.dart';
import 'package:trablock_flutter/src/model/TravelModel.dart';
import 'package:trablock_flutter/src/provider/SelectedTravelProvider.dart';
import 'package:trablock_flutter/src/widget/PlaceBlockWidget.dart';

class PlaceList extends StatefulWidget {
  const PlaceList({super.key});

  @override
  State<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    SelectedTravelProvider provider = Provider.of<SelectedTravelProvider>(context, listen: false);
    Travel _travel = Provider.of<SelectedTravelProvider>(context).travel;
    List<List<Place>> assignedPlaces = Provider.of<SelectedTravelProvider>(context).assignedPlaces;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: PageView(
          pageSnapping: true,
          controller: pageController,
          children: List<int>.generate(_travel.days, (index) => index+1).map((day) {
            return Builder(builder: (BuildContext context) {
              assignedPlaces[day-1].sort((a, b) => a.index.compareTo(b.index));
              return SingleChildScrollView(
                child: ReorderableColumn(
                  onReorder: (int oldIndex, int newIndex) {
                    provider.reorderPlace(oldIndex, newIndex, day-1);
                  },
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  header: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height*0.05,
                      child: Row(
                        children: [
                          Text(
                            "$day일차",
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Text(DateFormat("yyyy/MM/dd").format(DateFormat("yyyy/MM/dd").parse(_travel.period.split("-")[0]).add(Duration(days: day-1)))),
                        ],
                      ),
                    ),
                  ),
                  footer: Column(
                    children: [
                      Container(
                        height: 2,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.8-(150*assignedPlaces[day-1].length) > 0? MediaQuery.of(context).size.height*0.8-(150*assignedPlaces[day-1].length) : 0,
                        child: DragTarget<Place>(
                          builder: (context, candidateData, rejectedData) {
                            return Container();
                          },
                          onAccept: (place) {
                            provider.insertPlace(place, day-1);
                          },
                        ),
                      ),
                    ],
                  ),
                  children: <Widget>[
                    for (int placeIndex = 0; placeIndex < assignedPlaces[day-1].length; placeIndex++)
                      SizedBox(
                        key: Key('$placeIndex'),
                        height: 100,
                        child: Stack(
                          children: [
                            PlaceBlock(day: day, placeIndex: placeIndex,),
                            DragTarget<Place>(
                              builder:
                                  (context, candidatePlace, rejectedPlace) {
                                return Container(
                                  height: 50,
                                );
                              },
                              onAccept: (place) {
                                provider.insertPlaceAtUpperHalf(place, day-1, placeIndex);
                              },
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 50,
                                ),
                                DragTarget<Place>(
                                  builder:
                                      (context, candidatePlace, rejectedPlace) {
                                    return Container(
                                      height: 50,
                                    );
                                  },
                                  onAccept: (place) {
                                    provider.insertPlaceAtLowerHalf(place, day-1, placeIndex);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              );
            });
          }).toList()
      )
    );
  }
}