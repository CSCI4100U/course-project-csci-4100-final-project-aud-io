import 'package:cloud_firestore/cloud_firestore.dart';

class Profile{
  String? userName;
  String? phoneNum;
  String? country;
  String? city;
  String? email;
  String? birthday;
  String? _location;
  DocumentReference? reference;

  Profile({this.userName,this.phoneNum,this.country,this.city,this.birthday,this.email});

  set location(location){
    _location = location;
  }
  get location{
    return _location;
  }

  Profile.fromMap(var map, {this.reference}){
    this.userName = map['userName'];
    this.phoneNum = map['phoneNum'];
    this.country = map['country'];
    this.city = map['city'];
    this.birthday = map['birthday'];
    this.email = map['email'];
    this._location = map['location'];
  }

  Map<String,Object?> toMap(){
    return {
      'userName': this.userName,
      'phoneNum': this.phoneNum,
      'country': this.country,
      'city': this.city,
      'birthday': this.birthday,
      'email': this.email,
      'location': this._location
    };
  }
  @override
  String toString(){
    return "{ $userName : Phone#: $phoneNum. From $city, $country. Born $birthday. Email: $email";
  }
}