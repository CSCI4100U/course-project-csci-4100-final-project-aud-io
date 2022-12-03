import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserLocation {
  LatLng? latlng;
  String? email;
  DocumentReference? reference;

  UserLocation({
    this.latlng,
  });

  UserLocation.fromMap(var map, {this.reference}){
    this.latlng = map['location'];
    this.email = map['email'];
  }

  Map<String,Object?> toMap(){
    return {
      'location': this.latlng,
      'email': this.email,
    };
  }

  @override
  String toString(){
    return "{Location: $latlng, Email: $email}";
  }
}
