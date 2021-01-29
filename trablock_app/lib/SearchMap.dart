import 'dart:async';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'package:trablock_app/Data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';

class SearchMap extends StatefulWidget {
  static final String routeName = '/search';

  @override
  _SearchMapState createState() => _SearchMapState();
}

class _SearchMapState extends State<SearchMap> {
  final LatLng _center = const LatLng(0, 0);
  Completer<GoogleMapController> _controller = Completer();
  _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }

  final _textController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  static const kGoogleApiKey = "GoogleApiKey";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  @override
  Widget build(BuildContext context) {
    Travel _travel = ModalRoute.of(context).settings.arguments;
    return MaterialApp(
        home: Scaffold(
          body: Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(target: _center),
                onMapCreated: _onMapCreated,
              ),
              Positioned(
                top: 20,
                right: 15,
                left: 15,
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 15),
                              hintText: "Search..."),
                          controller: _textController,
                          onTap: () async {
                            // placeholder for our places search later
                            Prediction p = await PlacesAutocomplete.show(
                                context: context, apiKey: kGoogleApiKey);
                            displayPrediction(p,_travel);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );

  }

  Future<Null> displayPrediction(Prediction p, Travel travel) async {
    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      travel.candidateDestination.add(Destination(placeId, LatLng(lat,lng)));
    }
  }
}

