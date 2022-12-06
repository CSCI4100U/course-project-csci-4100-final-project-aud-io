import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:group_project/mainScreen_classes/MainScreen_Views/custom_circular_progress_indicator.dart';
import 'package:group_project/map_classes/map_model/userLocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:group_project/map_classes/map_model/map_constants.dart';
import 'package:group_project/user_classes/models/user_model.dart';
import 'package:latlong2/latlong.dart';
import '../../mainScreen_classes/MainScreen_Model/app_constants.dart';
import '../../user_classes/models/profile.dart';
import '../../user_classes/models/utils.dart';

/*
* Class shows a Flutter Map of all users who enable
* location permissions. It shows the number of friends
* each user has and the genres they have in common with
* the current user.
* */
class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}



class _ExplorePageState extends State<ExplorePage> with TickerProviderStateMixin{

  // Logical variables
  int selectedIndex = 0;
  bool permissionDenied = false;
  int? numFriends;

  // User Variables
  final _model = UserModel();
  List<Profile> otherUserFriendsList = [];
  List<Profile> currentUserFriendsList = [];

  // Map Variables
  late PageController pageController;
  late MapController mapController;
  late LatLng currentLocation;
  List<UserLocation> mapMarkers = [];
  bool locationLoaded = false;
  double zoomValue = 5;
  double maxZoom = 18;
  double minZoom = 5;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    mapController = MapController();
    _askForLocation();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                if(zoomValue < maxZoom){
                  // Increase Zoom on the map (Zoom in)
                  zoomValue++;
                  mapController.move(mapController.center, zoomValue);
                }
              });
            },
            icon: const Icon(Icons.zoom_in),
          ),
          IconButton(
            onPressed: (){
              setState(() {
                if(zoomValue > minZoom){
                  // Decrease Zoom on the map (Zoom out)
                  zoomValue--;
                  mapController.move(mapController.center, zoomValue);
                }
              });
            },
            icon: const Icon(Icons.zoom_out),
          ),
        ],
      ),
      body: locationLoaded ? Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
                minZoom: minZoom,
                maxZoom: maxZoom,
                zoom: zoomValue,
                center: currentLocation
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
                                padding: padding,
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: selectedIndex == i ?
                                  Colors.white : Colors.black,
                                  child: Text(mapMarkers[i].user!.userName![0].toUpperCase()),
                                ),
                              ),
                              onTap: (){
                                pageController.animateToPage(
                                    i,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut
                                );
                                selectedIndex = i;
                                currentLocation = getUserLocation(mapMarkers[i].user!).latlng!;
                                _animatedMapMove(currentLocation, mapController.zoom);
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
                    // resets number of friends so widget can reload
                    numFriends = null;
                    selectedIndex = value;
                    currentLocation = mapMarkers[value].latlng!;
                    _animatedMapMove(currentLocation, mapController.zoom);
                  });
                },
                itemBuilder: (context,index){

                  var user = mapMarkers[index].user;
                  getAllFriends(user!);

                  return Padding(
                    padding: padding,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: const Color.fromARGB(255, 23, 23, 23),
                      child: Row(
                        children: [
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                numFriends != null ? Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              _model.buildUserAvatar(user!, context),
                                              Expanded(
                                                child: SizedBox(
                                                      child: Text(
                                                        user?.userName ?? '',
                                                        style: const TextStyle(
                                                            fontSize: fontSize,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white
                                                        ),
                                                 )
                                                ),
                                              ),
                                              isAFriend(user) || _model.isCurrentUser(user) ?
                                              const Icon(Icons.mobile_friendly,color: Colors.white,) :
                                              IconButton(
                                                  onPressed: (){
                                                    setState(() {
                                                      _model.addToFriendList(currentUser, user);
                                                      _model.addToFriendList(user, currentUser);

                                                      // resets number of friends so widget can reload
                                                      numFriends = null;
                                                      Utils.showSnackBar("${FlutterI18n.translate(context, "snackbars.just_added")} ${user.userName} ${FlutterI18n.translate(context, "snackbars.as_friend")}",Colors.black);
                                                    });
                                                  },
                                                  icon: const Icon(Icons.person_add_alt_1,color: Colors.white,)
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: padding,
                                          child: Row(
                                            children: [
                                              const Icon(Icons.person,color: Colors.white,),
                                               Text(numFriends! != 1 ?
                                               "$numFriends ${FlutterI18n.translate(context, "titles.friend")}" :
                                               "1 ${FlutterI18n.translate(context, "titles.friend_sing")}",
                                                style: const TextStyle(
                                                    fontSize: fontSize,
                                                    color: Colors.white
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: padding,
                                          child: Row(
                                            children: [
                                              const Icon(Icons.favorite_border,color: Colors.white,),
                                              Text(getGenresInCommon(user) != "" ?
                                              " ${FlutterI18n.translate(context, "forms.texts.likes")} ${getGenresInCommon(user)}" :
                                              FlutterI18n.translate(context, "forms.texts.no_genres"),
                                                style: const TextStyle(
                                                    fontSize: fontSize,
                                                    color: Colors.white
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                ) : const CustomCircularProgressIndicator()
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  );
                }
            ),
          ),
        ]
      ) : permissionDenied ?
      AlertDialog(
        title: Text(FlutterI18n.translate(context, "dialogs.permission_denied")),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text(FlutterI18n.translate(context, "dialogs.understand"))
          ),
        ],
      ) : const CustomCircularProgressIndicator(),
    );
  }

  /*
  * Gets all relevant user location information and
  * updates the stream and the map
  * */
  _updateLocationStream(Position userLocation) async{

    userLocation = await Geolocator.getCurrentPosition();

    List<Placemark> places = await placemarkFromCoordinates(
        userLocation.latitude,
        userLocation.longitude
    );

    if(mounted){
      setState(() {
        currentLocation = LatLng(userLocation.latitude, userLocation.longitude);
        currentUser.location = "${userLocation.latitude},${userLocation.longitude}";

        // if location not already loaded
        if(!locationLoaded){

          String userAddress = "${places[0].subThoroughfare!} "
              "${places[0].thoroughfare!}";

          // if user address is unknown
          if(userAddress == " "){
            userAddress = FlutterI18n.translate(context, "forms.texts.user_unknown");
          }

          // updates user location on cloud storage
          UserModel().updateUser(currentUser);

          // shows current user address in a snackbar
          Utils.showSnackBar("${FlutterI18n.translate(
              context, "forms.texts.user_current")} "
              "${places[0].subThoroughfare!} "
              "${places[0].thoroughfare!}",
              Colors.black);

          getAllFriends(currentUser);
        }

        getAllUserMarkers();
        locationLoaded = true;
      });
    }
  }

  /*
  * Ensures location permissions are given, and listens to the
  * location stream to update the location. Also determines
  * whether or not permission was denied.
  * */
  _askForLocation() async{
    await Geolocator.isLocationServiceEnabled().then((value) => null);
    await Geolocator.requestPermission().then((value) => null);
    await Geolocator.checkPermission().then(
            (LocationPermission permission)
        {
          print("Check Location Permission: $permission");
          if(permission.toString().contains('denied')){
            permissionDenied = true;
            if(mounted){
              setState(() {

              });
            }
          }
        }
    );
    if(!permissionDenied){
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best
        ),
      ).listen(_updateLocationStream);
    }
  }

  /*
  * Gets all markers of the locations of the users
  * who allow location permissions on the Flutter
  * Map.
  * */
  getAllUserMarkers() async{
    List<Profile> allUsers = await _model.getAllUsers();
    for(Profile user in allUsers){
      final userLocation = getUserLocation(user);
      if(userLocation.user!=null){
        var existingLocation = mapMarkers.firstWhere((element) => element.user!.userName == userLocation.user!.userName, orElse: () => UserLocation());
        if(user.location != null && !mapMarkers.contains(existingLocation)){
          mapMarkers.add(userLocation);
        }
      }
    }
    if(mounted){
      setState(() {

      });
    }
  }

  /*
  * Function updates the list of all the friends of
  * the current user and the currently displayed user
  * on the map
  * */
  getAllFriends(Profile user) async{
    otherUserFriendsList = await _model.getFriendsList(user);
    currentUserFriendsList = await _model.getFriendsList(currentUser);
    numFriends = otherUserFriendsList.length;
    if(mounted) {
      setState(() {

      });
    }
  }

  /*
  * Returns whether or not a given user is a friend of
  * the current user
  * */
  bool isAFriend(Profile user){
    for(Profile friend in currentUserFriendsList){
      if(friend.userName == user.userName){
        return true;
      }
    }
    return false;
  }

  /*
  * Return a string of genres in common between
  * a given user and the current user
  * */
  getGenresInCommon(Profile user){

    if(user.favGenres != null && currentUser.favGenres != null){
      String genresInCommon = "";

      var currUserFavGenres = currentUser.favGenres;
      var otherUserFavGenres = user.favGenres;

      for(int i = 0; i < otherUserFavGenres.length; i++){
        if(currUserFavGenres.contains(otherUserFavGenres[i])){
          if(genresInCommon == ""){
            genresInCommon += otherUserFavGenres[i];
          }
          else{
            genresInCommon += ", ${otherUserFavGenres[i]}";
          }
        }
      }
      return genresInCommon;
    }
    return "";
  }

  /*
  * Returns the longitude and latitude (UserLocation)
  * of a given user.
  * */
  UserLocation getUserLocation(Profile user){
    List<String> locationFromDatabase = user.location.toString().split(",");

    if(user.location != null){
      double latitude = double.parse(locationFromDatabase[0]);
      double longitude = double.parse(locationFromDatabase[1]);
      return UserLocation(
          latlng: LatLng(latitude, longitude),
          user: user
      );
    }
    else{
      return UserLocation();
    }
  }

  /*
  * From Lecture 8b - Maps
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
