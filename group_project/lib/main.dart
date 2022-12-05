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
import 'package:group_project/MainScreen_Views/fav_genres_view.dart';
import 'package:group_project/music_classes/views/addPlaylist.dart';
import 'package:group_project/user_classes/models/user_model.dart';
import 'package:group_project/statistics_classes/views/statistics_chart.dart';
import 'package:group_project/statistics_classes/views/statistics_datatable.dart';
import 'package:group_project/user_classes/views/add_genre.dart';
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
          '/friendsList' : (context) => FriendList(title: FlutterI18n.translate(context, "titles.friend"),),
          '/addFriend' : (context) => AddFriendSearch(title: FlutterI18n.translate(context, "titles.add_friend"),userNameEntered: ""),
          '/playlists' : (context) => PlayListView(title: FlutterI18n.translate(context, "titles.genre")),
          '/addPlaylist' : (context) => AddPlaylistView(title: "Add Playlist",),
          '/settings' : (context) => SettingsView(title: FlutterI18n.translate(context, "titles.setting")),
          '/addGenre' : (context) => const AddGenre(title: "Add Genre"),
          '/favGenres' : (context) => const FavoriteGenresView(title: "Liked Genres",),
          '/explore' : (context) => ExplorePage(title: FlutterI18n.translate(context, "titles.explore"),),
          '/statistics' : (context) => StatisticsDataTable(title: FlutterI18n.translate(context, "titles.stats_table"),),
          '/statisticsChart' : (context) => StatisticsChart(title: FlutterI18n.translate(context, "titles.stats_chart"), frequencies: [],),
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
        automaticallyImplyLeading: false,
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
          SizedBox(
            width: 37,
            child: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                    value: 1,
                    child: Text('Change to EN')
                ),
                const PopupMenuItem(
                    value: 2,
                    child: Text('Change to FR')
                ),
                const PopupMenuItem(
                    value: 3,
                    child: Text('Change to ES')
                ),
              ],
              onSelected: (value) {
                if (value == 1){
                  print('Swapping to English');
                  Locale newLocale = Locale('en');
                  setState(() {
                    FlutterI18n.refresh(context, newLocale);
                  });
                } else if (value == 2){
                  print('Swapping to French');
                  Locale newLocale = Locale('fr');
                  setState(() {
                    FlutterI18n.refresh(context, newLocale);
                  });
                } else if (value == 3) {
                  print('Swapping to Spanish');
                  Locale newLocale = Locale('es');
                  setState(() {
                    FlutterI18n.refresh(context, newLocale);
                  });                }
              },
            ),
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
                                title: Text(FlutterI18n.translate(context, "titles.profile"),style: style,),
                                subtitle: Text(FlutterI18n.translate(context, "main.view_profile"), style: style,),
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
                            padding: padding,
                            width: 300,
                            decoration: const BoxDecoration(color: Color.fromRGBO(118, 149, 255, 1)),
                            child: ListTile(
                                title: Text(FlutterI18n.translate(context, "titles.friend"), style: style,),
                                subtitle: Text(FlutterI18n.translate(context, "main.view_friend"), style: style,),
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
                            padding: padding,
                            width: 300,
                            decoration: const BoxDecoration(color: Color.fromRGBO(167, 173, 253, 1)),
                            child: ListTile(
                                title: Text(FlutterI18n.translate(context, "titles.genre"), style: style,),
                                subtitle: Text(FlutterI18n.translate(context, "main.view_genre"), style: style,),
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
                            padding: padding,
                            width: 300,
                            decoration: const BoxDecoration(color: Color.fromRGBO(
                                149, 215, 250, 1.0)),
                            child: ListTile(
                                title: Text(FlutterI18n.translate(context, "titles.explore"), style: style,),
                                subtitle: Text(FlutterI18n.translate(context, "main.view_explore"), style: style,),
                                trailing: Icon(Icons.public)
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
