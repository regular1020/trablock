import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/model/PlaceModel.dart';
import 'package:trablock_flutter/src/provider/PlanDragStateProvider.dart';
import 'package:trablock_flutter/src/view/AddPlanView.dart';

import '../provider/SelectedTravelProvider.dart';

class LeftPlaceList extends StatelessWidget {
  const LeftPlaceList({super.key});

  Color? getColor(Place place) {
    switch (place.category) {
      case "관광지":
        return Colors.red.withOpacity(0.1);
      case "식당":
        return Colors.blue.withOpacity(0.1);
      case "이동":
        return Colors.yellow.withOpacity(0.1);
      case "숙소":
        return Colors.green.withOpacity(0.1);
      case "쇼핑":
        return Colors.purple.withOpacity(0.1);
      default:
        return Colors.blueGrey.withOpacity(0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Place> unassignedPlaces = Provider.of<SelectedTravelProvider>(context).unassignedPlaces;
    return SizedBox(
            width: MediaQuery.of(context).size.width * 0.3-3,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      "잔여일정",
                      style: TextStyle(fontSize: 20),
                    )),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: unassignedPlaces.length + 1,
                    itemBuilder: (context, index) {
                      if (index == unassignedPlaces.length) {
                        return TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: ((context) => AddPlanView())));
                            }, 
                            child: const Text("추가"));
                      } else {
                        return LongPressDraggable<Place>(
                          data: unassignedPlaces[index],
                          feedback: Container(
                            height: MediaQuery.of(context).size.width * 0.15,
                            width: MediaQuery.of(context).size.width * 0.25,
                            decoration: BoxDecoration(
                              color: getColor(unassignedPlaces[index]),
                            ),
                            child: Center(
                                child: Text(
                              unassignedPlaces[index].name,
                              style: const TextStyle(
                                color : Colors.black54,
                                fontSize: 15
                              ),
                            )),
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.width * 0.15,
                            width: MediaQuery.of(context).size.width * 0.25,
                            decoration: BoxDecoration(
                              color: getColor(unassignedPlaces[index]),
                            ),
                            child: Center(
                              child: Text(
                                unassignedPlaces[index].name,
                                style: const TextStyle(
                                  color : Colors.black54,
                                  fontSize: 15
                                ),
                              )
                            ),
                          ),
                          onDragStarted: () {
                            Provider.of<PlanDragStateProvider>(context, listen: false).moveStart();
                          },
                          onDragEnd: (details) {
                            Provider.of<PlanDragStateProvider>(context, listen: false).moveEnd();
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
  }
}