import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:group_project/MainScreen_Model/nav.dart';
import 'package:group_project/map_model/userLocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:group_project/map_model/map_constants.dart';
import 'package:group_project/user_classes/models/user_model.dart';
import 'package:group_project/user_classes/views/addFriend.dart';
import 'package:latlong2/latlong.dart';

import '../user_classes/models/profile.dart';
class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}



class _ExplorePageState extends State<ExplorePage> with TickerProviderStateMixin{

  int selectedIndex = 0;

  // User Variables
  final _model = UserModel();
  late Profile currentUser = Profile();
  List<Profile> allFriends = [];

  // Map Variables
  late PageController pageController;
  late MapController mapController; // = MapController();
  late LatLng currentLocation;
  List<UserLocation> mapMarkers = [];
  bool locationLoaded = false;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    mapController = MapController();
    getAllUserMarkers();
    _askForLocation();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBarForSubPages(context, widget.title),
      body: locationLoaded ? Stack(
        children: [
          FlutterMap(
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
                          height: 50,
                          width: 50,
                          point: mapMarkers[i].latlng!,
                          builder: (context) {
                            return GestureDetector(
                              child:
                              Container(
                                padding: EdgeInsets.all(10),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: selectedIndex == i ?
                                  Colors.white : Colors.black,
                                  //Todo: Replace with profile photo
                                  child: Icon(Icons.person),
                                ),
                              ),
                              onTap: (){
                                pageController.animateToPage(
                                    i,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut
                                );
                                selectedIndex = i;
                                currentLocation = getUserLocation(mapMarkers[i].user!).latlng!;
                                _animatedMapMove(currentLocation, 11.5);
                              },
                            );
                          }
                      ),
                  ]
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 2,
            height: MediaQuery.of(context).size.height*0.3,
            child: PageView.builder(
                controller: pageController,
                itemCount: mapMarkers.length,
                onPageChanged: (value){
                  setState(() {
                    selectedIndex = value;
                    currentLocation = mapMarkers[value].latlng!;
                    _animatedMapMove(currentLocation, 11.5);
                  });
                },
                itemBuilder: (context,index){
                  var user = mapMarkers[index].user;

                  return Padding(
                    padding: EdgeInsets.all(15),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),

                      ),
                      color: const Color.fromARGB(255, 30, 29, 29),
                      child: Row(
                        children: [
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    flex: 2, // expanding so it fills space (aesthetic)
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: [
                                              Expanded(child: _model.buildUserAvatar(user!, context)),
                                              Expanded(
                                                  child: Container(
                                                    width: 100,
                                                    child: Text(
                                                      user?.userName ?? '',
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white
                                                      ),
                                                    )
                                                  )
                                              ),
                                              Expanded(
                                                child: isAFriend(user)
                                                    ? Container(
                                                    width: 10,
                                                    color: Colors.grey,
                                                    padding: const EdgeInsets.all(10.0),
                                                    child: Row(
                                                      children: const [
                                                        Expanded(child: Text("FRIEND")),
                                                        Expanded(child: Icon(Icons.check))
                                                      ],
                                                    )
                                                ) : GestureDetector(
                                                  onTap: (){
                                                    // go to profile page of friend
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => AddFriendSearch(
                                                          title: "Add ${user.userName}", //Add Friends
                                                          userNameEntered: user.userName!,
                                                        ))
                                                    );
                                                  },
                                                  child: Container(
                                                      color: Colors.blue,
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: Row(
                                                        children: const [
                                                          Expanded(
                                                            flex: 2,
                                                              child: Text("SEARCH")
                                                          ),
                                                          Expanded(
                                                              flex: 1,
                                                              child:
                                                              Icon(Icons.search)
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                ),
                                              )


                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 10,),
                          // Expanded(
                          //     child: Padding(
                          //       padding: EdgeInsets.all(4),
                          //       child: ClipRRect(
                          //         borderRadius: BorderRadius.circular(10),
                          //         child: Image.network(mapMarkers[index].image),
                          //       ),
                          //     )
                          // )
                        ],
                      ),
                    ),
                  );
                }
            ),
          ),
        ]
      ) : Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }

  _updateLocationStream(Position userLocation) async{
    userLocation = await Geolocator.getCurrentPosition();
    if(mounted){
      setState(() {
        locationLoaded = true;
        currentLocation = LatLng(userLocation.latitude, userLocation.longitude);
        currentUser.location = "${userLocation.latitude},${userLocation.longitude}";
        UserModel().updateUser(currentUser);
      });
    }
  }

  _askForLocation() async{
    bool permissionDenied = false;
    Geolocator.isLocationServiceEnabled().then((value) => null);
    Geolocator.requestPermission().then((value) => null);
    Geolocator.checkPermission().then(
            (LocationPermission permission)
        {
          print("Check Location Permission: $permission");
          if(permission == "LocationPermission.denied"){
            permissionDenied = true;
          }
        }
    );
    await getCurrentUser(FirebaseAuth.instance.currentUser!.email!);

    if(!permissionDenied){
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best
        ),
      ).listen(_updateLocationStream);
    }
  }

  getCurrentUser(String email)async{
    currentUser = await _model.getUserByEmail(email);
    setState(() {
      print("CURRENT USER: $currentUser");
      currentUser;
    });
  }

  getAllUserMarkers() async{
    List<Profile> allUsers = await _model.getAllUsers();
    for(Profile user in allUsers){
      if(user.location != null){
        mapMarkers.add(getUserLocation(user));
      }
    }
    setState(() {
      print("MARKERS: $mapMarkers");
    });
  }

  /*
  * Function reloads friend stream and updates the
  * List of all the friends of the current user
  * */
  getAllFriends() async{
    allFriends = await _model.getFriendsList(currentUser);
  }

  isAFriend(Profile user){
    for(Profile friend in allFriends){
      if(friend.userName == user.userName){
        return true;
      }
    }
    return false;
  }
  
  UserLocation getUserLocation(Profile user){
    List<String> locationFromDatabase = user.location.toString().split(",");
    double latitude = double.parse(locationFromDatabase[0]);
    double longitude = double.parse(locationFromDatabase[1]);
    return UserLocation(
        latlng: LatLng(latitude, longitude),
        user: user
    );
  }

  /*
  * Completely Stolen Code from the Internet
  *
  * Needs: with TickerProviderStateMixin apart of State class
  * */
  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
    CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

}
