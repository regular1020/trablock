import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/model/PlaceModel.dart';
import 'package:trablock_flutter/src/model/TravelModel.dart';
import 'package:trablock_flutter/src/provider/PlanDragStateProvider.dart';
import 'package:trablock_flutter/src/provider/SelectedTravelProvider.dart';
import 'package:trablock_flutter/src/provider/TravelProvider.dart';
import 'package:trablock_flutter/src/widget/LeftPlaceListWidget.dart';
import 'package:trablock_flutter/src/widget/PlaceBlockWidget.dart';
import 'package:trablock_flutter/src/widget/PlaceListWidget.dart';

class TravelInfoView extends StatefulWidget {
  const TravelInfoView({Key? key}) : super(key: key);

  @override
  State<TravelInfoView> createState() => _TravelInfoViewState();
}

class _TravelInfoViewState extends State<TravelInfoView> {
  late Travel _travel;
  late List<Place> unassignedPlaces;
  late List<List<Place>> assignedPlaces;

  @override
  void initState() {
    _travel = Provider.of<SelectedTravelProvider>(context, listen: false).travel;
    Provider.of<SelectedTravelProvider>(context, listen: false).initTravel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    unassignedPlaces = Provider.of<SelectedTravelProvider>(context).unassignedPlaces;
    assignedPlaces = Provider.of<SelectedTravelProvider>(context).assignedPlaces;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _travel.places.forEach((element) {
            Provider.of<TravelProvider>(context, listen: false)
                .saveChangeToFireStore(element);
          });
        },
        child: const Icon(Icons.save),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blueGrey.withOpacity(0.5),
            height: MediaQuery.of(context).size.height*0.05,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${Provider.of<SelectedTravelProvider>(context).travel.destination} 여행",
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          Container(
            color: Colors.blueGrey.withOpacity(0.5),
            height: MediaQuery.of(context).size.height*0.05,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(Provider.of<SelectedTravelProvider>(context).travel.period),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                const PlaceList(),
                Container(
                  width: 3,
                  color: Colors.black,
                ),
                const LeftPlaceList(),
              ],
            ),
          ),
          if (Provider.of<PlanDragStateProvider>(context).moved) 
          Container(
            height: MediaQuery.of(context).size.height*0.1,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.red
            ),
            child: DragTarget<Place>(
              builder: (context, candidateData, rejectedData) {
                return const Icon(Icons.delete);
              },
              onAccept: (place) {
                Provider.of<SelectedTravelProvider>(context, listen: false).deletePlace(place);
              },
            ),
            
          )
        ],
      ),
    );
  }
}
