import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/model/PlaceModel.dart';
import 'package:trablock_flutter/src/provider/SelectedTravelProvider.dart';

class PlaceBlock extends StatelessWidget {
  const PlaceBlock({super.key, required this.day, required this.placeIndex});
  final int day;
  final int placeIndex;

  @override
  Widget build(BuildContext context) {
    Place place = Provider.of<SelectedTravelProvider>(context).assignedPlaces[day-1][placeIndex];
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15)),
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
                        place.name,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      )
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<SelectedTravelProvider>(context, listen: false).removePlaceFromDate(place.dateOfVisit, place.index);
                      },
                      child: const Text(
                        "삭제",
                        style: TextStyle(color: Colors.white),
                      ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${place.hour}시간 ${place.minute}분",
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ],
          )
        )
      );
  }
}