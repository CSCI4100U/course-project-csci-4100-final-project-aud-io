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
// * and view music others like and explore users
// * around the world.
// ********************************************************

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_project/MainScreen_Views/notifications.dart';
import 'package:group_project/music_classes/views/addPlaylist.dart';
import 'package:group_project/user_classes/models/user_model.dart';
import 'package:group_project/user_classes/views/genre_form.dart';
import 'package:group_project/user_classes/views/login_form.dart';
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
Widget logo = Container(
    padding: EdgeInsets.all(5.0),
    child: const Image(
      image: AssetImage('lib/images/audio_alt_beige2.png'),
      height: 125,
    ),
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
          '/profile' : (context) => const ProfileView(title: "Profile"),
          '/friendsList' : (context) => const FriendList(title: "Friends",),
          '/addFriend' : (context) => AddFriendSearch(title: "Add Friends",userNameEntered: ""),
          '/playlists' : (context) => PlayListView(title: "Genres"),
          '/addPlaylist' : (context) => AddPlaylistView(title: "Add Playlist",),
          '/settings' : (context) => const SettingsView(title: "Settings"),
          '/addGenre' : (context) => const GenreForm(title: "Add a Favourite Genre"),
          '/notifications' : (context) => const NotificationsView(title: "Notifications",),
          '/explore' : (context) => const ExplorePage(title: "Explore",),
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

  TextStyle style = const TextStyle(fontSize: 25);
  var padding = const EdgeInsets.all(10.0);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: widget.title,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/favGenres');
            },
            icon: Icon(Icons.favorite_border),
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
                            padding: padding,
                            width: 300,
                            decoration: const BoxDecoration(color: Color.fromRGBO(232, 173, 253, 1)),
                            child: ListTile(
                                title: Text("Profile",style: style,),
                                subtitle: Text("View profile!", style: style,),
                                trailing: const Icon(Icons.person_pin_rounded)
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
                            padding: padding,
                            width: 300,
                            decoration: const BoxDecoration(color: Color.fromRGBO(118, 149, 255, 1)),
                            child: ListTile(
                                title: Text("Friends", style: style,),
                                subtitle: Text("View friends!", style: style,),
                                trailing: const Icon(Icons.groups)
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
                            padding: padding,
                            width: 300,
                            decoration: const BoxDecoration(color: Color.fromRGBO(167, 173, 253, 1)),
                            child: ListTile(
                                title: Text("Genres", style: style,),
                                subtitle: Text("View genres!", style: style,),
                                trailing: const Icon(Icons.music_note)
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
                            padding: padding,
                            width: 300,
                            decoration: const BoxDecoration(color: Color.fromRGBO(
                                149, 215, 250, 1.0)),
                            child: ListTile(
                                title: Text("Explore", style: style,),
                                subtitle: Text("Travel the world!", style: style,),
                                trailing: const Icon(Icons.public)
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
