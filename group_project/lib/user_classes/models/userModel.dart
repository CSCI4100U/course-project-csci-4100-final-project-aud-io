import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'profile.dart';

class UserModel{
  /*
  * Insert newly signed up user into database
  * */
  Future insertUser(Profile user) async{
    print("Adding new user...");
    // Add user to 'users' collection
    FirebaseFirestore.instance.collection('users').doc().set(user.toMap());
    
    // Make a friendsList collection for the user
    CollectionReference friendsList = FirebaseFirestore.instance.collection('friendsList');
    FirebaseFirestore.instance.collection('users').doc(user.reference!.id)
        .collection('friendsList').add({});
    //print("Added data: $data");
  }

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
  Stream getAllFriends(Profile user) async*{

    print("Getting the friendsList...");
    if(user.reference!=null){
      print("Pls work lol");
      yield await FirebaseFirestore.instance.collection('users').doc(user.reference!.id)
          .collection('friendsList').get();
    }
    else{
      // For now return hardcoded user.reference.id because my code is bad lol
      yield await FirebaseFirestore.instance.collection('users').doc("uuz3yJIKsMrnPPsaqPXK")
          .collection('friendsList').get();
    }

  }

  Future updateUser(Profile user) async{
    print("Updating user info...");
    FirebaseFirestore.instance.collection('users').doc(user.reference!.id).update(user.toMap());
  }

  Future deleteUser(Profile user) async{
    user.reference!.delete();
  }

  /*
  * Function returns an individual user from a snapshot
  * */
  Profile getUserBySnapshot(BuildContext context, DocumentSnapshot userData){
    final user = Profile.fromMap(
        userData.data(),
        reference: userData.reference);
    return user;
  }
  // Future<Profile> getUserByUsername(String userName) async{
  //   Profile resultingUser = Profile();
  //   List<Profile> allUsers = await FirebaseFirestore.instance.collection('users').get()..map<Profile>((document){
  //     final user = Profile.fromMap(
  //         document,
  //         reference: document.reference);
  //     return user;
  //   }
  //   ).toList();
  //
  //   print("AL USERS: ${allUsers.toString()}");
  //   for(Profile user in allUsers){
  //     if(user.userName == userName){
  //       print("Getting resulting user...");
  //       resultingUser = user;
  //     }
  //   }
  //   return resultingUser;
  // }
}