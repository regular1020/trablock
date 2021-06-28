import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:trablock_app/Data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class SearchMap extends StatefulWidget {
  static final String routeName = '/search';

  @override
  _SearchMapState createState() => _SearchMapState();
}

class _SearchMapState extends State<SearchMap> {
  LatLng _center = const LatLng(0, 0);
  Completer<GoogleMapController> _controller = Completer();
  LatLng _address = LatLng(0.0, 0.0);
  Set<Marker> _markers = Set();
  _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }

  final _textController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  static const kGoogleApiKey = "AIzaSyAmvDTxVFoxZQqGo-55aD6kkPenMbot6SI";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  @override
  Widget build(BuildContext context) {
    Destination _destination = ModalRoute.of(context).settings.arguments;
    if(_destination.address != null){
      _center = _destination.address;
      _markers.add(
        Marker(
          markerId: MarkerId(_destination.name),
          position: _destination.address,
          infoWindow: InfoWindow(title: _destination.name),
        )
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('위치 검색')
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _center, zoom: 14),
            onMapCreated: _onMapCreated,
            markers: _markers,
            onCameraMove: (CameraPosition position) {
              if(_markers.length > 0) {
                Marker updatedMarker = _markers.first.copyWith(
                  positionParam: position.target,
                );
                setState(() {
                  _markers.clear();
                  _markers.add(updatedMarker);
                });
              }
              else{
                _markers.add(
                  Marker(
                    markerId: MarkerId(_destination.name),
                    position: position.target,
                    infoWindow: InfoWindow(title : _destination.name),
                  )
                );
              }
            },
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
                        displayPrediction(p, _destination);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }

  Future<Null> displayPrediction(Prediction p, Destination d) async {
    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);

      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      _address = LatLng(lat, lng);
      GoogleMapController newController = await _controller.future;

      newController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _address,zoom: 14,)));
    }
  }
}

