// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Google Maps App",
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static final Marker _kAkdenizUniMarker = Marker(
    markerId: MarkerId('_kAkdeniz'),
    infoWindow: InfoWindow(title: 'Akdeniz Universtesi'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(36.88621127842176, 30.6793212890625),
  );

  static final Marker _kGooglePlexMarker = Marker(
    markerId: const MarkerId('_kGooglePlex'),
    infoWindow: InfoWindow(title: 'Google Plex'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    position: LatLng(37.42796133580664, -122.085749655962),
  );

  static final Marker _kLakeMarker = Marker(
    markerId: MarkerId('_kLake'),
    infoWindow: InfoWindow(title: 'Lake View'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    position: LatLng(37.43296265331129, -122.08832357078792),
  );

  static const Polyline _road =
      Polyline(polylineId: PolylineId('toThelake'), color: Colors.red, points: [
    LatLng(37.43296265331129, -122.08832357078792),
    LatLng(37.42796133580664, -122.085749655962)
  ]);

  static const Polygon _polygonRoad = Polygon(
      polygonId: PolygonId('toTheLakePg'),
      strokeColor: Colors.orange,
      points: [
        LatLng(37.43296265331129, -122.08832357078792),
        LatLng(37.42796133580664, -122.085749655962)
      ]);

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _AkdenizUni = CameraPosition(
      target: LatLng(36.88621127842176, 30.6793212890625),
      tilt: 30.440717697143555,
      zoom: 25.151926040649414);

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        markers: {
          _kGooglePlexMarker,
          _kAkdenizUniMarker,
          _kLakeMarker,
        },
        // polylines: {_road},
        // polygons: {_polygonRoad},
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the UNIIIII!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_AkdenizUni));
  }
}
