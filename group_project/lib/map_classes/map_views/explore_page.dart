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
class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}



class _ExplorePageState extends State<ExplorePage> with TickerProviderStateMixin{

  int selectedIndex = 0;
  bool permissionDenied = false;

  // User Variables
  final _model = UserModel();
  List<Profile> otherUserFriendsList = [];
  List<Profile> currentUserFriendsList = [];
  int? numFriends;

  // Map Variables
  late PageController pageController;
  late MapController mapController; // = MapController();
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
                                  //Todo: Replace with profile photo
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
                                               Text(numFriends! != 1 ? "$numFriends ${FlutterI18n.translate(context, "titles.friend")}": "1 ${FlutterI18n.translate(context, "titles.friend_sing")}",
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
      ) : permissionDenied
          ? AlertDialog(
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
        if(!locationLoaded){
          String userAddress = "${places[0].subThoroughfare!} "
              "${places[0].thoroughfare!}";
          if(userAddress == " "){
            userAddress = FlutterI18n.translate(context, "forms.texts.user_unknown");
          }
          UserModel().updateUser(currentUser);
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
  * Function reloads friend stream and updates the
  * List of all the friends of the current user
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

  bool isAFriend(Profile user){
    for(Profile friend in currentUserFriendsList){
      if(friend.userName == user.userName){
        return true;
      }
    }
    return false;
  }

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
