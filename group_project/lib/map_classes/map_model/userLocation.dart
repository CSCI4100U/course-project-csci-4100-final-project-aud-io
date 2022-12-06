import 'package:latlong2/latlong.dart';
import '../../user_classes/models/profile.dart';

class UserLocation {
  LatLng? latlng;
  Profile? user;

  UserLocation({
    this.latlng,this.user
  });

  @override
  String toString(){
    return "Latlng: $latlng, User: ${user!.userName}";
  }
}
