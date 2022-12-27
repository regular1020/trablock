import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/model/PlaceModel.dart';
import 'package:trablock_flutter/src/model/TravelModel.dart';
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
      appBar: AppBar(
        title: Text("${_travel.destination}여행"),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _travel.places.forEach((element) {
            Provider.of<TravelProvider>(context, listen: false)
                .saveChangeToFireStore(element);
          });
        },
        child: const Icon(Icons.save),
      ),
      body: Row(
        children: const [
          PlaceList(),
          LeftPlaceList(),
        ],
      ),
    );
  }
}
