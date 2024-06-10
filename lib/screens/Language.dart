// Importing necessary packages
import 'package:digividya/screens/AppIntroVideoPlayer.dart';
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
    var argument = (ModalRoute.of(context)!.settings.arguments ?? <String, dynamic>{}) as Map;

    // Assign values from arguments to local variables
    userName = argument['Username'];
    mobilenumber = argument['mobileNo'];
    city = argument['city'];
    deviceId = argument['deviceId'];

    print("$deviceId"); // Print deviceId for debugging

    // Return a Scaffold widget
    return Scaffold(
      body: SingleChildScrollView( // Allow the screen to scroll
        child: Container(
          height: MediaQuery.of(context).size.height * 1, // Set container height to full screen height
          width: MediaQuery.of(context).size.width * 1, // Set container width to full screen width
          child: Column(
            children: [
              Expanded(
                child: Container(
                    width: MediaQuery.of(context).size.width, // Set width to full screen width
                    height: 275, // Fixed height
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/Language.webp'), // Set background image
                            fit: BoxFit.fill)),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 70, 15, 15), // Set padding
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
                height: MediaQuery.of(context).size.height / 1.6, // Set container height to 60% of screen height
                width: MediaQuery.of(context).size.width / 1.2, // Set container width to 83% of screen width
                child: Stack(
                  children: [
                    Positioned(
                      top: MediaQuery.of(context).size.height / 9.3, // Position element from top
                      left: MediaQuery.of(context).size.width / 10.2, // Position element from left
                      right: MediaQuery.of(context).size.width / 10.2, // Position element from right
                      child: GestureDetector(
                          // Navigate to download app intro video in Marathi
                          onTap: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: ((context) => vediopage(
                                    language: 'Marathi', // Pass language parameter
                                    userName: userName, // Pass userName parameter
                                    mobilenumber: mobilenumber, // Pass mobilenumber parameter
                                    city: city, // Pass city parameter
                                    device_id: deviceId, // Pass deviceId parameter
                                  )),
                            ));
                          },
                          child: Container(
                            height: 75, // Fixed height
                            width: 220, // Fixed width
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/Button-23-min.webp'), // Set button background image
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
                      top: MediaQuery.of(context).size.height / 3.4, // Position element from top
                      left: MediaQuery.of(context).size.width / 10.2, // Position element from left
                      right: MediaQuery.of(context).size.width / 10.2, // Position element from right
                      child: GestureDetector(
                          // Navigate to download app intro video in Hindi
                          onTap: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: ((context) => vediopage(
                                    language: 'Hindi', // Pass language parameter
                                    userName: userName, // Pass userName parameter
                                    mobilenumber: mobilenumber, // Pass mobilenumber parameter
                                    device_id: deviceId, // Pass deviceId parameter
                                    city: city, // Pass city parameter
                                  )),
                            ));

                            // showDialog(
                            //   context: context,
                            //   barrierDismissible: false,
                            //   builder: (context) {
                            //     var commingsoonContext = context;
                            //     return commingSoonAlertbox(
                            //         comingSoonDialogContext:
                            //             commingsoonContext);
                            //   },
                            // );
                          },
                          child: Container(
                            height: 75, // Fixed height
                            width: 220, // Fixed width
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/Button-23-min.webp'), // Set button background image
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
                    // GestureDetector(
                    //     //Navigate to download english app intro
                    //     onTap: () {
                    //       Navigator.of(context)
                    //           .pushReplacement(MaterialPageRoute(
                    //               builder: ((context) => downloadScreen()),
                    //               settings: RouteSettings(arguments: {
                    //                 'language': 'english',
                    //                 'userName': userName,
                    //                 'mobilenumber': mobilenumber,
                    //                 'city': city,
                    //                 'deviceid': deviceId
                    //               })));
                    //     },
                    //     child: Container(
                    //       height: 75,
                    //       width: 220,
                    //       decoration: BoxDecoration(
                    //           image: DecorationImage(
                    //               image: AssetImage(
                    //                   'assets/images/Button-23-min.webp'),
                    //               fit: BoxFit.fill)),
                    //       child: Center(
                    //           child: Text(
                    //         'English',
                    //         style: TextStyle(
                    //             fontFamily: 'Fontmain',
                    //             color: Colors.white,
                    //             fontSize: 26),
                    //       )),
                    //     )),
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
