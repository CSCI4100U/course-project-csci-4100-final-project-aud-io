import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../user_classes/models/profile.dart';

class UserLocation {
  LatLng? latlng;
  Profile? user;
  DocumentReference? reference;

  UserLocation({
    this.latlng,this.user
  });
}
