import 'package:cloud_firestore/cloud_firestore.dart';

class Profile{
  String? userName;

  //private, not in constructor
  String? _password;

  String? phoneNum;
  String? country;
  String? city;
  String? birthday;
  DocumentReference? reference;

  Profile({this.userName,this.phoneNum,this.country,this.city,this.birthday});

  String? get password => _password;

  set password(password){
    _password = password;
  }

  Profile.fromMap(var map, {this.reference}){
    this.userName = map['userName'];
    this.phoneNum = map['phoneNum'];
    this.country = map['country'];
    this.city = map['city'];
    this.birthday = map['birthday'];
  }

  Map<String,Object?> toMap(){
    return {
      'userName': this.userName,
      'phoneNum': this.phoneNum,
      'country': this.country,
      'city': this.city,
      'birthday': this.birthday
    };
  }
  @override
  String toString(){
    return "{ $userName : Phone#: $phoneNum. From $city, $country. Born $birthday.";
  }
}