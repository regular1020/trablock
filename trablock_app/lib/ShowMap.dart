import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trablock_app/Data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowMap extends StatefulWidget {
  static final String routeName = '/map';
  final bool isSelecting;


  ShowMap({this.isSelecting = false});

  @override
  _ShowMapState createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set();
  _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }


  @override
  Widget build(BuildContext context) {
    List<Destination> desList = ModalRoute.of(context).settings.arguments;

    for(int i = 0; i < desList.length; i++){
      _markers.add(
        Marker(
          markerId: MarkerId(desList[i].name),
          position: desList[i].address,
          infoWindow: InfoWindow(title: desList[i].name)
        )
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('지도'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: desList[0].address, zoom: 12),
        onMapCreated: _onMapCreated,
        markers: _markers,
      ),
    );
  }
}
