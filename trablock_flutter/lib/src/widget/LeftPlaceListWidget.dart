import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/model/PlaceModel.dart';
import 'package:trablock_flutter/src/view/AddPlanView.dart';

import '../provider/SelectedTravelProvider.dart';

class LeftPlaceList extends StatelessWidget {
  const LeftPlaceList({super.key});

  @override
  Widget build(BuildContext context) {
    List<Place> unassignedPlaces = Provider.of<SelectedTravelProvider>(context).unassignedPlaces;
    return SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
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
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: LongPressDraggable<Place>(
                            data: unassignedPlaces[index],
                            feedback: Container(
                              height: MediaQuery.of(context).size.width * 0.25,
                              width: MediaQuery.of(context).size.width * 0.25,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                  child: Text(
                                unassignedPlaces[index].name,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
                            ),
                            child: Container(
                              height: MediaQuery.of(context).size.width * 0.25,
                              width: MediaQuery.of(context).size.width * 0.25,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                  child: Text(
                                unassignedPlaces[index].name,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
                            ),
                          ),
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