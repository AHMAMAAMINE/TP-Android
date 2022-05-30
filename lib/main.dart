import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart' as locations;
late GoogleMapController googleMapController;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final Map<String, Marker> _markers = {};
  final Map<String, Circle> _circles = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    googleMapController = controller;

    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {

              print(office.lat);
          final marker = Marker(
            markerId: MarkerId(office.name),
            position: LatLng(office.lat, office.lng),
            infoWindow: InfoWindow(
              title: office.name,
              snippet: office.address,
            ),
          );
          _markers[office.name] = marker;



      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Google Office Locations'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(0, 0),
            zoom: 2,
          ),
          circles: _circles.values.toSet(),
          markers: _markers.values.toSet(),

        ),
          floatingActionButton: FloatingActionButton(
            onPressed:() async {
              googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target:LatLng(45.4861470,9.1895460),zoom: 14)));
              const marker = Marker(
                markerId: MarkerId("Position"),
                position: LatLng(45.4861470,9.1895460),
                infoWindow: InfoWindow(

                    snippet: '45.4861470' + " " +'9.1895460'

                ),
              );
              const circle = Circle(
                  circleId: CircleId("area"),
                  center: LatLng(45.4861470,9.1895460),
                  radius: 900000,
                  fillColor: Colors.black38,
                  strokeColor: Colors.red,
                  strokeWidth: 1
              );


              setState(() {
                _markers["Position"]=marker;
                _circles["area"]=circle;
              });

            },
            child: Icon(Icons.navigation),
            backgroundColor: Colors.green,
          )
      ),
    );
  }
}