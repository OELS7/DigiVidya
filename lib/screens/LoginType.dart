// Import necessary Dart and Flutter packages
import 'dart:math'; // Import dart:math for generating random numbers
import 'package:digividya/screens/Free_Time.dart'; // Import Free_Time screen
import 'package:digividya/screens/Register.dart'; // Import Register screen
import 'package:flutter/material.dart'; // Import Flutter material package

// Define the loginType widget as a StatefulWidget
class loginType extends StatefulWidget {
  const loginType({super.key});

  @override
  State<loginType> createState() => _loginTypeState();
}

// Define the state class for loginType
class _loginTypeState extends State<loginType> {
  // Declare variables for device ID and mobile number
  static String? device_id;
  String MobileNo = "";

  @override
  void initState() {
    // Initialize the state
    super.initState();
    device_id = generateDevicId();
    generateMobileNo();
    debugPrint(
        "%%%%%%%%%%%%%%%%%%%%%%%% This is device id $device_id %%%%%%%%%%%%%%%%%%%%%");
    // MobileNo = generateMobileNo(); // Generate random mobile number
  }

  // Function to generate random device ID
  String generateDevicId() {
    String stringPattern =
        "+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789!@#%^&*()"; // Define pattern for random string
    Random random = Random(); // Create a Random object
    return String.fromCharCodes(Iterable.generate(
      50, // Generate a string of length 50
      (_) => stringPattern.codeUnitAt(random
          .nextInt(stringPattern.length)), // Pick random character from pattern
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Return a Scaffold widget
    return Scaffold(
      body: SafeArea(
          child: Stack(
        // Use a Stack to layer widgets
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'assets/images/Registration & Pay Now UI_ 23 Jan Updated-04-04.png'), // Set background image
                  fit: BoxFit.fill), // Fit the image to fill the container
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height *
                  0.65, // Position the container from the top
              left: MediaQuery.of(context).size.width *
                  0.14, // Position the container from the left
              right: MediaQuery.of(context).size.width *
                  0.14, // Position the container from the right
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height *
                      0.25, // Set container height to 25% of screen height
                  width: MediaQuery.of(context).size.width *
                      1, // Set container width to full screen width
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceAround, // Distribute space evenly around children
                    children: [
                      GestureDetector(
                        // Define action for Register button tap
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  Register(), // Navigate to Register screen
                              settings: RouteSettings(
                                  arguments: {"DeviceId": device_id})));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height *
                              0.09, // Set button height
                          width: MediaQuery.of(context).size.width *
                              0.59, // Set button width
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  30), // Round the corners
                              color: Colors.white), // Set button color
                          child: Center(
                              child: Text(
                            "Register", // Set button text
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: "Fontmain"),
                          )),
                        ),
                      ),
                      GestureDetector(
                        // Define action for Guest Mode button tap
                        onTap: () {
                          Future.delayed(Duration(milliseconds: 100), () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        freetime(), // Navigate to freetime screen
                                    settings: RouteSettings(arguments: {
                                      "userName":
                                          "Guest", // Pass userName as "Guest"
                                      "mobileNo":
                                          MobileNo, // Pass generated mobile number
                                      "city": "Thane", // Pass city as "Thane"
                                      'DeviceId':
                                          device_id, // Pass generated device ID
                                      "language":
                                          'Marathi' // Pass language as "Marathi"
                                    })));
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height *
                              0.09, // Set button height
                          width: MediaQuery.of(context).size.width *
                              0.59, // Set button width
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  30), // Round the corners
                              color: Colors.white), // Set button color
                          child: Center(
                              child: Text(
                            "Guest Mode", // Set button text
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: "Fontmain"),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          // Positioned(child: Container( decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/app_log/DigiVidyaLogo.webp"))),)),
        ],
      )),
    );
  }

  // Function to generate random mobile number
  generateMobileNo() {
    Random random = Random(); // Create a Random object
    String mobilenumber =
        ""; // Initialize an empty string for the mobile number
    for (int mobNumber = 0; mobNumber < 10; mobNumber++) {
      // Loop 10 times to generate a 10-digit number
      mobilenumber += random
          .nextInt(10)
          .toString(); // Append a random digit to the mobile number
    }
    MobileNo = mobilenumber;
    debugPrint(
        "%%%%%%%%%%%%%%%%%%%%%% Generated Mobile Number First time: $MobileNo   %%%%%%%%%%%%%%%%%%%%%");
  }
}
