import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digividya/screens/HomePage.dart';
import 'package:digividya/widgets/InternalServerError.dart';
import 'package:digividya/widgets/InternetErrorDialog.dart';
import 'package:digividya/screens/LoginType.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class Splash extends StatefulWidget {
  Splash({
    super.key,
  });

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
// Initialize variable to store server device ID
  String serverDevice_Id = "";

// Initialize variable to store guest name
  String GuestName = "";

// Initialize variable to store guest ID
  String GuestId = "";

// Initialize variable to store values from the app info file
  var values;

// Create an instance of Connectivity to check network status
  Connectivity _connectivity = Connectivity();

// Getter for the title (not used in this context, placeholder)
  get title => null;

// Override the initState method to perform initializations when the widget is created
  @override
  void initState() {
    // Call the parent class's initState method
    super.initState();

    // Call the method to navigate to the next page based on the app logic
    _goToNextPage();
  }

// Override the build method to describe how to display the widget
  @override
  Widget build(BuildContext context) {
    // Return a Scaffold widget, which provides the structure for the screen
    return Scaffold(
      // Define the body of the Scaffold within a SafeArea
      body: SafeArea(
        // Create a container to hold the splash screen content
        child: Container(
          // Apply a decoration to the container
          decoration: BoxDecoration(
              // Set a background image for the container
              image: DecorationImage(
                  // Load the image from the specified asset path
                  image: AssetImage('assets/images/Splash-Screen-2.webp'),
                  // Ensure the image fills the container
                  fit: BoxFit.fill)),
          // Set the height of the container to fill the screen height
          height: MediaQuery.of(context).size.height * 1,
          // Set the width of the container to fill the screen width
          width: MediaQuery.of(context).size.width * 1,
        ),
      ),
    );
  }

// Function to get the device ID
  Future<String> getDeviceId(String userId) async {
    // Create a map with the user ID to send in the API request
    Map<String, dynamic> UserId = {'user_id': userId};

    // Print the user ID for debugging purposes
    //print("%%%%%%%%%%%%%%%%%%%%%%%% User Id : $userId %%%%%%%%%%%%%%%%%%%%%");

    // Define the URL for the API call to get the device ID
    // var url = "http://192.168.1.19/prachi/DigiVidyaAPI/api/singleUserDeviceID";
    var url = "https://digividya.in/DigiVidyaAPI/api/singleUserDeviceID";

    try {
      // Make a POST request to the API with the user ID
      var response = await http.post(Uri.parse(url), body: UserId);

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Parse the JSON response and get the device ID
        Map<String, dynamic> jsonRespons =
            jsonDecode(response.body.toString().replaceAll("\n", " "));
        // Print the device ID for debugging purposes
        //print("%%%%%%%%%%%%%%%%%%%%%%%%%%% device Id From Server : ${jsonRespons['device_id'].toString()} %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        // Return the device ID as a string
        return jsonRespons['device_id'].toString();
      } else {
        // Print the response status code and body for debugging purposes
        // print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Response Status code : ${response.statusCode} %%%%%%%%%%%%%%%%%%%%%%");
        // print("${response.body}");

        // If the device ID is not retrieved, show an error dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            var internetErrorContext = context;
            return InternalserverError(
                InternalserverErrorContext: internetErrorContext,
                ErrorTitle: "Poor Connection",
                Description:
                    "Maybe you have a poor internet connection. Please try again.",
                ButtonText: "ok",
                retryButton: () {
                  Future.delayed(Duration(milliseconds: 80), () {
                    getDeviceId(userId);
                  });
                  Navigator.of(internetErrorContext).pop();
                });
          },
        );
        // Return an empty string if the device ID is not retrieved
        return "";
      }
    } on http.ClientException catch (e) {
      // Print the exception message for debugging purposes
      print(e.toString());
      // Return an empty string in case of an exception
      return "";
    }
  }

// Function to generate device ID and create JSON file
  void _goToNextPage() async {
    // Check the internet connectivity status
    final _checkConnectivity = await _connectivity.checkConnectivity();

    // Before login, check the internet connectivity of the device
    if (_checkConnectivity == ConnectivityResult.none) {
      // If no internet connectivity, show an error dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          var internetErrorContext = context;
          return InternetErrorDialog(
            internetErrorDialogContext: internetErrorContext,
            message: "Please check your internet Connectivity.",
          );
        },
      );
    } else {
      // Delay for 1 second before proceeding
      Future.delayed(
        const Duration(seconds: 1),
        () async {
          // Get the application support directory path
          var dir = (await getApplicationSupportDirectory()).path;
          // Define the path to the app info JSON file
          File appinfoFile = File("$dir/appInfo.json");

          // Check if the app info JSON file exists
          if (appinfoFile.existsSync()) {
            // Print a message indicating the file exists
            print("App config File Exist");

            // Read the contents of the app info JSON file
            values = jsonDecode(appinfoFile.readAsStringSync());

            // Print the contents of the JSON file for debugging
            print(values);

            // Check if the user is a guest
            if (values['UserName'] == 'Guest') {
              // Navigate to the home page if the user is a guest
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => homePage(),
                ),
              );
            } else {
              try {
                // Get the device ID for the user
                await getDeviceId(values['User_Id'].toString()).then((value) {
                  serverDevice_Id = value;
                });
              } on Exception catch (e) {
                // Print the exception if an error occurs
                print("The exception thrown is  : ${e}");
              }

              // Print the user's device ID for debugging
              print(values['userDevice_Id'].toString());

              // Check if the user's device ID matches the server's device ID and is not empty
              if ((values['userDevice_Id'].toString() == serverDevice_Id) &&
                  (values['userDevice_Id'].toString() != "")) {
                // Navigate to the home page if the device IDs match
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => homePage(),
                  ),
                );
              } else {
                // Show an error dialog if the device IDs do not match
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    var internetErrorDialog = context;
                    return InternalserverError(
                      InternalserverErrorContext: internetErrorDialog,
                      ErrorTitle: "Poor Connection",
                      Description:
                          "Maybe you have a poor internet connection. Please try again.",
                      ButtonText: "ok",
                      retryButton: () {
                        Future.delayed(Duration(milliseconds: 30), () async { 
                          print("%%%%%%%%%%%%%%%%%%%%%%% Testing Deletion %%%%%%%%%%%%%%%%%%");
                          (values['userDevice_Id'].toString() !=
                                  serverDevice_Id)
                              ? await appinfoFile
                                  .delete(recursive: true)
                                  .then((_) {
                                    print("App Info File Deleted.................");
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => loginType(),
                                    ),
                                  );
                                })
                              : () {
                                print("%%%%%%%%%%%%%%%%%%%%% File Not Find %%%%%%%%%%%%%%%%%%%");
                              };
                        });
                        Navigator.of(internetErrorDialog).pop();
                      },
                    );
                  },
                );
              }
            }
          } else {
            // Navigate to the login page if the app info JSON file does not exist
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => loginType(),
              ),
            );
          }
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
