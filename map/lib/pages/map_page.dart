// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);
 
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

  late double lat=0;
  late double long=0;
  late Marker _currentMarker;
  Set<Marker> markers = { _kGooglePlexMarker, _kAkdenizUniMarker};


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



      //Getting current location
      Future<Position> getCurrentLocation() async{
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        /*if(!serviceEnabled){
          return Future.error('Location services are disabled.');
        }*/
        LocationPermission permission= await Geolocator.checkPermission();
        if(permission == LocationPermission.denied){
          permission = await Geolocator.requestPermission();
          if(permission == LocationPermission.denied){
            return Future.error('Location permissions are denied!');
          }
        }

        if(permission == LocationPermission.deniedForever){
          return Future.error('Location permissions are permanently denied, we cannot request permissions.');

        }
        return await Geolocator.getCurrentPosition();
      }

      

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        markers: markers,
        // polylines: {_road},
        // polygons: {_polygonRoad},
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToTheLocation,
        child: Icon(Icons.my_location),
      ),
    );

    

  }

  void _setCurrentMarker(){
    while(true){
      Future.delayed(const Duration(milliseconds: 500), () {
          }
          );
    }
  }

  Future<void> _goToTheLocation() async {
    getCurrentLocation().then((value){
        lat = value.latitude;
        long = value.longitude;
        });
    if(lat==0 && long==0){
      return;
    }

    _currentMarker = Marker(
        markerId: MarkerId('_current'),
        infoWindow: InfoWindow(title: 'MyLocation'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(lat, long),
        );

    setState(() {
        if(!markers.contains(_currentMarker)){
        markers.add(_currentMarker);
        }
        });
    CameraPosition currentLocation = CameraPosition(
        target: LatLng(lat, long),
        zoom: 19.151926040649414
        );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(currentLocation));
  }

}
