import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/model/PlaceModel.dart';
import 'package:trablock_flutter/src/model/TravelModel.dart';
import 'package:trablock_flutter/src/provider/SelectedTravelProvider.dart';
import 'package:trablock_flutter/src/widget/PlaceBlockWidget.dart';

class PlaceList extends StatelessWidget {
  const PlaceList({super.key});

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
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "$day일차",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ReorderableListView(
                      onReorder: (int oldIndex, int newIndex) {
                        provider.reorderPlace(oldIndex, newIndex, day-1);
                      },
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      children: <Widget>[
                        if (assignedPlaces[day-1].isEmpty)
                          Container(
                            key: const Key('0'),
                            child: DragTarget<Place>(
                              builder: (context, candidatePlace, rejectedPlaces) {
                                return Container(
                                  height: MediaQuery.of(context).size.height * 0.8,
                                );
                              },
                              onAccept: (place) {
                                provider.insertPlace(place, day-1);
                              },
                            ),
                          )
                        else
                          for (int placeIndex = 0; placeIndex < assignedPlaces[day-1].length; placeIndex++)
                            SizedBox(
                              key: Key('$placeIndex'),
                              height: assignedPlaces[day-1][placeIndex].hour * 120.0 + assignedPlaces[day-1][placeIndex].minute * 2.0 + 4,
                              child: Stack(
                                children: [
                                  PlaceBlock(day: day, placeIndex: placeIndex,),
                                  DragTarget<Place>(
                                    builder:
                                        (context, candidatePlace, rejectedPlace) {
                                      return Container(
                                        height: (assignedPlaces[day-1][placeIndex].hour * 120.0 + assignedPlaces[day-1][placeIndex].minute * 2.0) /2,
                                      );
                                    },
                                    onAccept: (place) {
                                      provider.insertPlaceAtUpperHalf(place, day-1, placeIndex);
                                    },
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: (assignedPlaces[day-1][placeIndex].hour * 120.0 + assignedPlaces[day-1][placeIndex].minute * 2.0) / 2,
                                      ),
                                      DragTarget<Place>(
                                        builder:
                                            (context, candidatePlace, rejectedPlace) {
                                          return Container(
                                            height: (assignedPlaces[day-1][placeIndex].hour * 120.0 + assignedPlaces[day-1][placeIndex].minute * 2.0) / 2,
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
                  ),
                ],
              );
            });
          }).toList()
      )
    );
  }
}