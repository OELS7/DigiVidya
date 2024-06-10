import 'package:digividya/Routes/app_routes.dart'; // Importing necessary package
import 'package:flutter/material.dart'; // Importing necessary package
import 'package:shared_preferences/shared_preferences.dart'; // Importing necessary package

class fragmentFrame extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>(); // Global key for navigator state
  fragmentFrame({Key? key}) : super(key: key); // Constructor

  @override
  State<fragmentFrame> createState() =>
      _fragmentFrameState(navigatorState: navigatorKey); // Creating state
}

class _fragmentFrameState extends State<fragmentFrame> {
  int lessionNumber = 0; // Variable to store lesson number
  late SharedPreferences _sectionCompleted; // Shared preferences for section completion
  bool sectionFlag = false; // Flag to indicate section completion
  GlobalKey<NavigatorState> navigatorState; // Global key for navigator state

  _fragmentFrameState({required this.navigatorState}); // Constructor

  @override
  void initState() {
    super.initState();
    initSharePreference(); // Initialize shared preferences
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Hiding debug banner
      initialRoute: "/", // Initial route
      onGenerateRoute: app_routes.generatorRoute, // Generating routes
    );
  }

  // Method to initialize shared preferences
  void initSharePreference() async {
    _sectionCompleted = await SharedPreferences.getInstance(); // Getting shared preferences instance
    sectionFlag = _sectionCompleted.getBool("sectionCompletedFag") ?? false; // Getting section completion flag
  }

  // Uncomment the following method if needed
  // void createAppLink(String? path) async {
  //   final UserData = {"section": (1).toString(), "topic_count": (5).toString()};
  //   final uri = Uri.https("digividya.in", path ?? "", UserData);
  //   print("%%%%%%%%%%%%%%%%%%% ${uri} %%%%%%%%%%%%%%%%%%%%%");
  // }
}
