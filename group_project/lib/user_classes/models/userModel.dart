import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'profile.dart';

class UserModel{
  /*
  * Insert newly signed up user into database
  * */
  // Future insertUser(Profile user) async{
  //   print("Adding new user...");
  //   FirebaseFirestore.instance.collection('users').doc().set(user.toMap());
  //   //print("Added data: $data");
  // }

  /*
  * Returns all users in database for addFriend query
  * */
  Stream getAllUsers() async*{

    print("Getting the users...");
    yield await FirebaseFirestore.instance.collection('users').get();
  }

  /*
  * Returns all friends in database for a specific user
  * */
  // Stream getAllFriends(Profile user) async*{
  //
  //   print("Getting the users...");
  //   yield await FirebaseFirestore.instance.collection('users').get();
  // }

  // Future updateProfile(Profile user) async{
  //   print("Updating grade...");
  //   FirebaseFirestore.instance.collection('grades').doc(user.reference!.id).update(user.toMap());
  // }
  //
  // Future deleteUser(Profile user) async{
  //   user.reference!.delete();
  // }

  /*
  * Function returns an individual user from a snapshot
  * */
  Profile getUser(BuildContext context, DocumentSnapshot userData){
    final user = Profile.fromMap(
        userData.data(),
        reference: userData.reference);

    return user;
  }
}