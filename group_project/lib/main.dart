import 'package:flutter/material.dart';
import 'nav.dart';

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
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Aud.io'),
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

    //Replacement can be MenuObjects class of name, route,
    List options = ["Login/Logout","Profile","Friends","Playlists"];
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
            onPressed: (){},
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
        child: Container(
          padding: const EdgeInsets.all(50),
          child: ListView.separated(
              itemBuilder: (context,index){
                return Container(
                  height: 50,
                  child: TextButton(
                    child: Text("${options[index]}",
                      style: const TextStyle(
                          color: Colors.black
                      ),
                    ),
                    onPressed: (){
                      print("You pressed button ${options[index]}!");
                    },
                  ),
                );
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
