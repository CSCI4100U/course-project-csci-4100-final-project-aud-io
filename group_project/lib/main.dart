import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:group_project/side_menu_item.dart';
import 'package:group_project/user_classes/friends.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aud.io',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: AnimatedSplashScreen(
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/audio.png"),
          ],
        ),
        duration: 15000,
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: Colors.deepPurpleAccent,
        nextScreen: const MyHomePage(title: 'Aud.io'),
        splashIconSize: 500,
      ),
        //Routes For Later
        routes: {
          // '/loginForm' : (context) => LoginForm(),
          // '/profile' : (context) => ProfileView(),
          '/friendList' : (context) => const FriendList(title: "Friends",),
          // '/playlists' : (context) => PlaylistView(),
          // '/settings' : (context) => SettingsView(),
        }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {

    List options = [
      SideMenuItem(title:"Login",route:"/loginForm"),
      SideMenuItem(title:"Profile",route:"/profile"),
      SideMenuItem(title:"Friends",route:"/friendList"),
      SideMenuItem(title:"Playlists",route:"/playlists"),
    ];
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.home),
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
                return options[index];
              },
              separatorBuilder: (context,index){
                return Divider();
              },
              itemCount: options.length
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
