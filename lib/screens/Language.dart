// Importing necessary packages
import 'package:digividya/screens/Free_Time.dart';
import 'package:flutter/material.dart';

// Define the languagePage widget as a StatefulWidget
class languagePage extends StatefulWidget {
  const languagePage({super.key});

  @override
  State<languagePage> createState() => _languagePageState();
}

// Define the state class for languagePage
class _languagePageState extends State<languagePage> {
  // Declare variables for user information
  String userName = "";
  String mobilenumber = "";
  String city = "";
  String deviceId = "";

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments passed to this route
    var argument = (ModalRoute.of(context)!.settings.arguments ??
        <String, dynamic>{}) as Map;

    // Assign values from arguments to local variables
    userName = argument['Username'];
    mobilenumber = argument['mobileNo'];
    city = argument['city'];
    deviceId = argument['DeviceId'];

    print("$deviceId"); // Print deviceId for debugging

    // Return a Scaffold widget
    return Scaffold(
      body: SingleChildScrollView(
        // Allow the screen to scroll
        child: Container(
          height: MediaQuery.of(context).size.height *
              1, // Set container height to full screen height
          width: MediaQuery.of(context).size.width *
              1, // Set container width to full screen width
          child: Column(
            children: [
              Expanded(
                child: Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Set width to full screen width
                    height: 275, // Fixed height
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/Language.webp'), // Set background image
                            fit: BoxFit.fill)),
                    child: Container(
                      padding:
                          EdgeInsets.fromLTRB(15, 70, 15, 15), // Set padding
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "Choose Your", // Display title text
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Fontmain',
                                  color: Colors.white),
                            ),
                            Text(
                              " Language", // Display subtitle text
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Fontmain',
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    )),
              ),
              Container(
                height: MediaQuery.of(context).size.height /
                    1.6, // Set container height to 60% of screen height
                width: MediaQuery.of(context).size.width /
                    1.2, // Set container width to 83% of screen width
                child: Stack(
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).size.height /
                          9.3, // Position element from top
                      left: MediaQuery.of(context).size.width /
                          10.2, // Position element from left
                      right: MediaQuery.of(context).size.width /
                          10.2, // Position element from right
                      child: GestureDetector(
                          // Navigate to download app intro video in Marathi
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => freetime(),
                                    settings: RouteSettings(arguments: {
                                      "userName": userName,
                                      "mobileNo": mobilenumber,
                                      "city": city,
                                      "DeviceId": deviceId,
                                      "language": "marathi"
                                    })));
                          },
                          child: Container(
                            height: 75, // Fixed height
                            width: 220, // Fixed width
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/Button-23-min.webp'), // Set button background image
                                    fit: BoxFit.fill)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'मराठी', // Display button text in Marathi
                                style: TextStyle(
                                    fontFamily: 'Fontmain',
                                    color: Colors.white,
                                    fontSize: 26),
                              ),
                            ),
                          )),
                    ),
                    Positioned(
                      top: MediaQuery.sizeOf(context).height /
                          3.4, // Position element from top
                      left: MediaQuery.sizeOf(context).width /
                          10.2, // Position element from left
                      right: MediaQuery.sizeOf(context).width /
                          10.2, // Position element from right
                      child: GestureDetector(
                          // Navigate to download app intro video in Hindi
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => freetime(),
                                    settings: RouteSettings(arguments: {
                                      "userName": userName,
                                      "mobileNo": mobilenumber,
                                      "city": city,
                                      "DeviceId": deviceId,
                                      "language": "marathi"
                                    })));
                          },
                          child: Container(
                            height: 75, // Fixed height
                            width: 220, // Fixed width
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/Button-23-min.webp'), // Set button background image
                                    fit: BoxFit.fill)),
                            child: Center(
                                child: Text(
                              'हिंदी', // Display button text in Hindi
                              style: TextStyle(
                                  fontFamily: 'Fontmain',
                                  color: Colors.white,
                                  fontSize: 26),
                            )),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
