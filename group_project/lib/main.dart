// *******************************************************
// *                  WELCOME TO AUD.io
// *------------------------------------------------------
// *
// * Developers:
// * -Rajiv Williams
// * -Matthew Sharp
// * -Alessandro Prataviera
// * -Mathew Kasbarian
// *
// * Description:
// * This application allow you to add new friends
// * (notification for friend request coming soon),
// * and create and collaborate on music playlists
// * using a Spotify SDK (Currently doing research).
// *
// * The user also can view their own profile and
// * add genres (Local Storage). Also, the user
// * can search for friends and add them (Cloud Storage).
// ********************************************************

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/MainScreen_Views/notifications.dart';
import 'package:group_project/music_classes/views/addPlaylist.dart';
import 'package:group_project/statistics_classes/views/statistics_chart.dart';
import 'package:group_project/statistics_classes/views/statistics_datatable.dart';
import 'package:group_project/user_classes/views/genre_form.dart';
import 'package:group_project/user_classes/views/login_form.dart';
import 'package:group_project/MainScreen_Views/side_menu_item.dart';
import 'package:group_project/user_classes/views/addFriend.dart';
import 'package:group_project/music_classes/views/playlist_view.dart';
import 'package:group_project/user_classes/views/friends_list.dart';
import 'package:group_project/user_classes/models/utils.dart';
import 'package:group_project/user_classes/views/profile_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'MainScreen_Views/settings_view.dart';
import 'map_views/explore_page.dart';

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
        routes: {
          '/home' : (context) => MyHomePage(title: logo,),
          '/profile' : (context) => ProfileView(title: "Profile", currentUserEmail: FirebaseAuth.instance.currentUser!.email),
          '/friendsList' : (context) => const FriendList(title: "Friends",),
          '/addFriend' : (context) => AddFriendSearch(title: "Add Friends",userNameEntered: ""),
          '/playlists' : (context) => PlayListView(title: "Playlists"),
          '/addPlaylist' : (context) => AddPlaylistView(title: "Add Playlist",),
          '/settings' : (context) => const SettingsView(title: "Settings"),
          '/addGenre' : (context) => const GenreForm(title: "Add a Favourite Genre"),
          '/notifications' : (context) => const NotificationsView(title: "Notifications",),
          '/explore' : (context) => const ExplorePage(title: "Explore",),
          '/statistics' : (context) => const Statistics_DataTable(title: "Statistics Data Table",),
          '/statisticsChart' : (context) => StatisticsChart(title: "Statistics Data Table", frequencies: [],),
        },
        localizationsDelegates: [
          FlutterI18nDelegate(
            missingTranslationHandler: (key,locale){
              print("MISSING KEY: $key, Language Code: ${locale!.languageCode}");
            },
            translationLoader: FileTranslationLoader(
              useCountryCode: false,
              fallbackFile: 'en',
              basePath: 'assets/i18n'
            ),
          ),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'),
          Locale('fr'),
          Locale('es'),
        ],
          );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final Widget title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    //final user = FirebaseAuth.instance.currentUser;

    List sideMenuOptions = [
      TextButton(
        onPressed: (){
          FirebaseAuth.instance.signOut();
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
              Navigator.pushNamed(context, '/notifications');
            },
            icon: const Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/settings');
            },
            icon: Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
              Container(
                height: 400,
                alignment: Alignment.center,
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
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
                            Navigator.pushNamed(context, '/profile');
                          },
                        ),
                    ),
                    Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
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
                    ),
                    Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
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
                            Navigator.pushNamed(context, '/playlists');
                          },
                        ),
                    ),
                    Expanded(
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            width: 300,
                            decoration: BoxDecoration(color: Color.fromRGBO(
                                149, 215, 250, 1.0)),
                            child: ListTile(
                                title: Text("Explore", style: style,),
                                subtitle: Text("Travel the world!", style: style,),
                                trailing: Icon(Icons.search)
                            ),
                          ),
                          onTap: (){
                            // Go to playlists Page
                            Navigator.pushNamed(context, '/explore');
                          },
                        ),
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
