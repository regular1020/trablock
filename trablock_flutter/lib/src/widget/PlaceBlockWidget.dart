import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/model/PlaceModel.dart';
import 'package:trablock_flutter/src/provider/SelectedTravelProvider.dart';

class PlaceBlock extends StatelessWidget {
  const PlaceBlock({super.key, required this.day, required this.placeIndex});
  final int day;
  final int placeIndex;

  Color? getColor(Place place) {
    switch (place.category) {
        case "관광지":
          return Colors.red.withOpacity(0.2);
        case "식당":
          return Colors.blue.withOpacity(0.2);
        case "이동":
          return Colors.yellow.withOpacity(0.2);
        case "숙소":
          return Colors.green.withOpacity(0.2);
        case "쇼핑":
          return Colors.purple.withOpacity(0.2);
        default:
          return Colors.blueGrey.withOpacity(0.2);
      }
  }

  @override
  Widget build(BuildContext context) {
    Place place = Provider.of<SelectedTravelProvider>(context).assignedPlaces[day-1][placeIndex];
    return Column(
      children: [
        Container(
          height: 2,
          color: Colors.grey,
        ),
        Expanded(
          child: Row(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width*0.6,
                  decoration: BoxDecoration(
                    color: getColor(place),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                              child: Text(
                                place.name,
                                style: const TextStyle(fontSize: 15),
                              )
                            ),
                            TextButton(
                              onPressed: () {
                                Provider.of<SelectedTravelProvider>(context, listen: false).removePlaceFromDate(place.dateOfVisit, place.index);
                              },
                              child: const Text(
                                "삭제",
                                style: TextStyle(color: Colors.black54),
                              ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left : 4.0),
                        child: Row(
                          children: [
                            Text(
                              place.category,
                              style: const TextStyle(color: Colors.black54),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              "${place.hour}시간 ${place.minute}분",
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left : 4.0),
                        child: Text(place.memo, style: const TextStyle(color: Colors.black54),),
                      )
                    ],
                  )
                ),
              if(place.startHour != null && place.startMinute.toString().length == 2)
                Expanded(
                  child: Text("${place.startHour}:${place.startMinute}"),
                )
              else if (place.startHour != null)
                Expanded(
                  child: Text("${place.startHour}:0${place.startMinute}")
                )
              else
                Expanded(child: Container()),
            ],
          ),
        ),
        // Container(
        //   height: 2,
        //   color: Colors.grey,
        // ),
      ],
    );
  }
}