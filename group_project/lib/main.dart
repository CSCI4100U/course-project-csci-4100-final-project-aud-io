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
  image: AssetImage('lib/images/audio_alt_beige2.png'),
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
          '/friendsList' : (context) => const FriendList(title: "Friends",),
          '/addFriend' : (context) => const AddFriendSearch(title: "Add Friends",),
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
      SideMenuItem(title:"Friends",route:"/friendsList"),
      SideMenuItem(title:"Playlists",route:"/playlists"),
      SideMenuItem(title:"Settings",route:"/settings"),
    ];
    TextStyle style = TextStyle(fontSize: 25);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 110,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
              Container(
                height: 300,
                alignment: Alignment.center,
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        width: 300,
                        decoration: BoxDecoration(color: Color.fromRGBO(232, 173, 253, 1)),
                        child: ListTile(
                          title: Text("Profile",style: style,),
                          subtitle: Text("View profile!", style: style,),
                            trailing: Icon(Icons.person_pin_rounded)
                        ),
                      ),
                      onTap: (){
                        // Go to friends_list Page
                        // Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        width: 300,
                        decoration: BoxDecoration(color: Color.fromRGBO(118, 149, 255, 1)),
                        child: ListTile(
                          title: Text("Friends", style: style,),
                          subtitle: Text("View friends!", style: style,),
                            trailing: Icon(Icons.groups)
                        ),
                      ),
                      onTap: (){
                        // Go to friends_list Page
                        Navigator.pushNamed(context, '/friendsList');
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        width: 300,
                        decoration: BoxDecoration(color: Color.fromRGBO(167, 173, 253, 1)),
                        child: ListTile(
                          title: Text("Playlists", style: style,),
                          subtitle: Text("View playlists!", style: style,),
                          trailing: Icon(Icons.music_note)
                        ),
                      ),
                      onTap: (){
                        // Go to playlists Page
                        // Navigator.pushNamed(context, '/playlists');
                      },
                    ),
                  ],
                ),

              ),
        ],
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
        child: const Icon(Icons.playlist_add),
        tooltip: "Add Playlist",
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
