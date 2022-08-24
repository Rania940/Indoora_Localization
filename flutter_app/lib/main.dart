import 'dart:async';
import 'package:flutter/material.dart';
import 'package:blinking_point/blinking_point.dart';
// import 'package:tuple/tuple.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:http/http.dart' as http;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(

    options: const FirebaseOptions(
      apiKey: "AIzaSyDkMOq6kTAj8zCLdmFYG0SXrvlZJa-rGTc",
      authDomain: "https://task0esp8266-default-rtdb.firebaseio.com",
      databaseURL: "https://task0esp8266-default-rtdb.firebaseio.com",
      appId: "1:578798010503:android:fddeee04e72ccda317b822",
      messagingSenderId: "578798010503",
      projectId: "task0esp8266",
     ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indoor Localization',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( 
      //  child: AspectRatio(
        //  aspectRatio: 299/730,
         child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/image1.jpeg"),
                  fit: BoxFit.fill)
          ,),
        child: Mypoint(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height), //grbe t7ote el parent aspect ratio bel image w el child da gowah
            ),
      // ),
      )
    );
  }
  
}


class Mypoint extends StatefulWidget
{
  const Mypoint(this.widthOfParent, this.heightOfParent, {Key key}) : super(key: key);
  // const Mypoint(this.widthOfParent, this.heightOfParent);

  final double widthOfParent;
  final double heightOfParent;

  
  @override
  State<Mypoint> createState() => _MypointState();
}

class _MypointState extends State<Mypoint>{
  Timer timer;
  double x = 0.0;
  double y = 0.0;
  int label = 0;
  // int count = 0;
  final dbRef = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
  }
  // Future<String> getJsonFromFirebase() async {
  //     String url = "https://indoor-localization-prediction-default-rtdb.firebaseio.com";
  //     http.Response response = await http.get(Uri.parse(url));
  //     return response.body;
  //   }


  void _update(Timer timer) {
    setState(() {
      // print("hi");
      switch(label){
        case 0: // Lectures Hall
          x = 0.0 + (widget.widthOfParent * 0.25);
          y = 0.0 - (widget.heightOfParent * 0.55);
          break;
        case 1: // Hallway2
          x = 0.0 + (widget.widthOfParent/25.0);
          y =  0.0 - (widget.heightOfParent * 0.5);
          break;
        case 2: // Hallway3
          x = 0.0 + (widget.widthOfParent/25.0);
          y = 0.0 - (widget.heightOfParent * 0.25);
          break;
        case 3: // Hallway4
          x = 0.0 + (widget.widthOfParent * 0.04);
          y = 0.0 + (widget.heightOfParent * 0.12);
          break;
        case 4:
          x = 0.0 - (widget.widthOfParent * 0.2);
          y = 0.0 + (widget.heightOfParent * 0.23);
          break;

      }

    });
  }

  @override
  Widget build(BuildContext context) {
      return StreamBuilder(
      stream: dbRef.child('room').onValue,

      builder: (context, snapshot){
        Widget widget2;
        if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data.snapshot.value != null) {
                // print(snapshot.data.snapshot.value);
                label = snapshot.data.snapshot.value;
                timer = Timer.periodic(
                    const Duration(milliseconds: 5000), _update);
                // print(x);
                // print(y);

                widget2 = Center(
                  child: BlinkingPoint(
                          xCoor: x,
                          yCoor: y,
                          pointColor: Colors.red,
                          pointSize: 5.0,
                  ),
                );
              }
              else{
                widget2 = const Center(child: CircularProgressIndicator());
              }
          return widget2;

      });
    
    
    }

  // @override
  // void dispose() {
  //   super.dispose();
  //   timer?.cancel();
  // }
}


//Lectures hall door
// xCoor: 0.0 + (widget.widthOfParent * 0.1),
// yCoor: 0.0 - (widget.heightOfParent * 0.73),


// Lectures hall - 0
// xCoor: 0.0 + (widget.widthOfParent * 0.25),
// yCoor: 0.0 - (widget.heightOfParent * 0.55),

// Shared office
// xCoor: 0.0 + (widget.widthOfParent/25.0),
// yCoor: 0.0 - (widget.heightOfParent * 0.88),


// door bet hallway1 and hallway2
// xCoor: 0.0 + (widget.widthOfParent/25.0),
// yCoor: 0.0 - (widget.heightOfParent * 0.75),


// Hallway1
// xCoor: 0.0 + (widget.widthOfParent/25.0),
// yCoor: 0.0 - (widget.heightOfParent * 0.78),


// Hallway2 - 1
// xCoor: 0.0 + (widget.widthOfParent/25.0),
// yCoor: 0.0 - (widget.heightOfParent * 0.5),

// Hallway3 - 2
// xCoor: 0.0 + (widget.widthOfParent/25.0),
// yCoor: 0.0 - (widget.heightOfParent * 0.25),


//Hallway4 - 3
// xCoor: 0.0 + (widget.widthOfParent/25.0),
// yCoor: 0.0 - (widget.heightOfParent * 0.3),
// or to stop  before electonics lab
// xCoor: 0.0 + (widget.widthOfParent * 0.04),
// yCoor: 0.0 + (widget.heightOfParent * 0.12),

// Electronics lab  - 4
// xCoor: 0.0 - (widget.widthOfParent * 0.2),
// yCoor: 0.0 + (widget.heightOfParent * 0.23),


// Electronics lab door
// xCoor: 0.0 - (widget.widthOfParent * 0.03),
// yCoor: 0.0 + (widget.heightOfParent * 0.19),


// door bet hallway4 and hallway5
// xCoor: 0.0 - (widget.widthOfParent * 0.03),
// yCoor: 0.0 + (widget.heightOfParent * 0.59),


// Hallway5
// xCoor: 0.0 - (widget.widthOfParent * 0.15),
// yCoor: 0.0 + (widget.heightOfParent * 0.55),