import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:group_project/MainScreen_Model/nav.dart';
import 'package:group_project/map_model/geolocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:group_project/map_model/map_constants.dart';
import 'package:group_project/user_classes/models/user_model.dart';
import 'package:latlong2/latlong.dart';

import '../user_classes/models/profile.dart';
class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}



class _ExplorePageState extends State<ExplorePage> {

  // User Variables
  final _model = UserModel();
  late Profile currentUser = Profile();

  // Map Variables
  late MapController mapController; // = MapController();
  late LatLng currentLocation;
  List<UserLocation> mapMarkers = [];
  bool locationLoaded = false;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _askForLocation();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBarForSubPages(context, widget.title),
      body: locationLoaded ? FlutterMap(
        mapController: mapController,
        options: MapOptions(
            minZoom: 5,
            maxZoom: 18,
            zoom: 13,
            center: currentLocation ?? MapConstants.defaultLocation
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: MapConstants.mapBoxStyleId,
          ),
          MarkerLayerOptions(
              markers: [
                for( int i = 0; i < mapMarkers.length; i++)
                  Marker(
                      height: 40,
                      width: 40,
                      point: mapMarkers[i].latlng!,
                      builder: (context) {
                        return Container(
                          child: IconButton(
                            onPressed: () {
                              // setState(() {
                              //   currentLocation = mapMarkers[i].latlng;
                              //   MapConstants.defaultLocation = mapMarkers[i].latlng;
                              // });
                            },
                            icon: Icon(Icons.circle),
                            color: Colors.red,
                            iconSize: 45,
                          ),
                        );
                      }
                  ),
              ]
          ),
        ],
      ) : Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }

  _updateCurrentLocation() async{
    Position userLocation = await Geolocator.getCurrentPosition();
    setState(() {
      locationLoaded = true;
      currentLocation = LatLng(userLocation.latitude, userLocation.longitude);
    });
  }

  _updateLocationStream(Position userLocation) async{
    userLocation = await Geolocator.getCurrentPosition();
    if(mounted){
      print("CURR USER REFERENCE: ${currentUser.reference}");
      setState(() {
        locationLoaded = true;
        currentLocation = LatLng(userLocation.latitude, userLocation.longitude);
        currentUser.location = "${userLocation.latitude},${userLocation.longitude}";
        UserModel().updateUser(currentUser);
      });
    }
    /*E/flutter ( 4153): This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree (e.g., whose parent widget no longer includes the widget in its build). This error can occur when code calls setState() from a timer or an animation callback.
E/flutter ( 4153): The preferred solution is to cancel the timer or stop listening to the animation in the dispose() callback. Another solution is to check the "mounted" property of this object before calling setState() to ensure the object is still in the tree.
E/flutter ( 4153): This error might indicate a memory leak if setState() is being called because another object is retaining a reference to this State object after it has been removed from the tree. To avoid memory leaks, consider breaking the reference to this object during dispose().*/
  }

  _askForLocation() async{
    Geolocator.isLocationServiceEnabled().then((value) => null);
    Geolocator.requestPermission().then((value) => null);
    Geolocator.checkPermission().then(
            (LocationPermission permission)
        {
          print("Check Location Permission: $permission");
        }
    );
    await getCurrentUser(FirebaseAuth.instance.currentUser!.email!);
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best
      ),
    ).listen(_updateLocationStream);
  }

  getCurrentUser(String email)async{
    currentUser = await _model.getUserByEmail(email);
    setState(() {
      print("CURRENT USER: $currentUser");
      currentUser;
    });
  }
}
