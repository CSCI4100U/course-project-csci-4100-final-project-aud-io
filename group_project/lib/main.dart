import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/user_classes/views/auth_page.dart';
import 'package:group_project/user_classes/models/authenticate_user.dart';
import 'package:group_project/user_classes/views/login_form.dart';
import 'package:group_project/MainScreen_Views/side_menu_item.dart';
import 'package:group_project/user_classes/views/addFriend.dart';
import 'package:group_project/user_classes/views/friends_list.dart';
import 'package:group_project/user_classes/models/utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// Aud.io logo at the top of the menu
Image logo = const Image(
  image: AssetImage('lib/images/audio_alt_beige.png'),
);

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: Utils.messengerKey,
        title: 'Aud.io',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: buildSplashScreen(),
        //Routes For Later
        routes: {
          '/home' : (context) => MyHomePage(title: logo,),
          // '/loginForm' : (context) => LoginForm(),
          // '/profile' : (context) => ProfileView(),
          '/friendList' : (context) => const FriendList(title: "Friends",),
          '/addFriend' : (context) => const AddFriendSearch(title: "Search Friends to Add",),
          // '/playlists' : (context) => PlaylistView(),
          // '/settings' : (context) => SettingsView(),
        }
        );
  }
}

//Todo: make this boolean functional
bool isLoggedIn = false;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final Widget title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    List sideMenuOptions = [
      TextButton(
        onPressed: (){
          FirebaseAuth.instance.signOut();
          // setState(() {
          //   isLoggedIn = false;
          //   //Todo: go back to /login
          // });
        },
        child: const Text(
          "Logout",
          style: TextStyle(fontSize: 30),
        ),
      ),
      SideMenuItem(title:"Profile",route:"/profile"),
      SideMenuItem(title:"Friends",route:"/friendList"),
      SideMenuItem(title:"Playlists",route:"/playlists"),
      SideMenuItem(title:"Settings",route:"/settings"),
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: widget.title,
        actions: [
          IconButton(
            onPressed: (){
              //Call async function that goes to route "/notifications"
              //Navigator.pushNamed(context, '/notifications');
            },
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: (){
              //Call async function that goes to route "/settings"
            },
            icon: Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: const Text("This is the home page"),
            )
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Container(
          padding: const EdgeInsets.all(50),
          child: ListView.separated(
              itemBuilder: (context,index){
                return sideMenuOptions[index];
              },
              separatorBuilder: (context,index){
                return Divider();
              },
              itemCount: sideMenuOptions.length
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.add),

      )
      ,
    );

  }
}

/*
* Function returns Custom SplashScreen
* */
Widget buildSplashScreen(){
  return AnimatedSplashScreen(
    splash: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("lib/images/audio.png"),
      ],
    ),
    splashTransition: SplashTransition.fadeTransition,
    pageTransitionType: PageTransitionType.fade,
    backgroundColor: Colors.deepPurpleAccent,
    nextScreen: LoginForm(title: logo), // Change to Login Later
    splashIconSize: 500,
  );
}
