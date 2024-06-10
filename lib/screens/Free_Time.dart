import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digividya/screens/HomePage.dart';
import 'package:digividya/widgets/InternalserverError.dart';
import 'package:digividya/widgets/SubmittingIndecator.dart';
import 'package:digividya/widgets/userAlredyExist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:digividya/Services/notificationServices.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart' as tz;

class freetime extends StatefulWidget {
  const freetime({super.key});

  @override
  State<freetime> createState() => _freetimeState();
}

class _freetimeState extends State<freetime> {
  // Declare a nullable String variable to store the selected time
String? selectedTime;

// Declare and initialize double variables for screen height and width
double ScreenHiegth = 0, ScreenWidth = 0;

// Declare and initialize a String variable to store the time zone
String timeZone = "";

// Declare and initialize a String variable to store the user name
String userName = "";

// Declare and initialize a String variable to store the mobile number
String mobileNumber = "";

// Declare and initialize a String variable to store the city
String city = "";

// Declare and initialize a String variable to store the device ID
String device_id = "";

// Declare and initialize a String variable to store the language
String language = "";

// Create an instance of the Connectivity class to check network connectivity
Connectivity _connectivity = Connectivity();

// Declare a variable to store the context for the submitting indicator
var SubmittingIndecatorContext;

// Override the initState method to perform initial setup
@override
void initState() {
  super.initState();
  // Call the getTimeZone method to retrieve the current time zone
  getTimeZone();
}


// Override the build method to define the UI
@override
Widget build(BuildContext context) {
  // Set the screen height using MediaQuery to get the current screen height
  ScreenHiegth = MediaQuery.of(context).size.height;
  // Set the screen width using MediaQuery to get the current screen width
  ScreenWidth = MediaQuery.of(context).size.width;

  // Retrieve the arguments passed to the route and cast them to a Map
  var arguments = (ModalRoute.of(context)!.settings.arguments ?? <String, String>{}) as Map;

  // Assign values from the arguments to the respective variables
  userName = arguments['userName'];
  mobileNumber = arguments['mobileNo'];
  city = arguments['city'];
  device_id = arguments['device_id'];
  language = arguments['language'];

  // Return a Scaffold widget as the main structure of the UI
  return Scaffold(
    // Use SingleChildScrollView to enable scrolling if the content overflows
    body: SingleChildScrollView(
      // Create a container to hold the entire UI with specified height and width
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            // Container for the header with an image background
            Container(
              width: MediaQuery.of(context).size.width,
              height: 275,
              decoration: BoxDecoration(
                // Set the background image of the header
                image: DecorationImage(
                  image: AssetImage('assets/images/Language.webp'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 70, 15, 15),
                child: Center(
                  child: Column(
                    children: [
                      // Display the text "Choose Your" with specified style
                      Text(
                        "Choose Your",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Fontmain',
                          color: Colors.white,
                        ),
                      ),
                      // Display the text "Free Time" with specified style
                      Text(
                        "Free Time",
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Fontmain',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Container for the timer pop-up
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.627,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                child: Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        // On tap, call the pickedTime method
                        onTap: () async {
                          pickedTime(context);
                        },
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 40),
                            height: 75,
                            width: 220,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/Button-23-min.webp'),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Center(
                              // Display the "Pick Time" text with specified style
                              child: Text(
                                'Pick Time',
                                style: TextStyle(
                                  fontFamily: 'Fontmain',
                                  color: Colors.white,
                                  fontSize: 26,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


// Define the getTimeZone method as an asynchronous function
getTimeZone() async {
  // Retrieve the local timezone using FlutterTimezone.getLocalTimezone()
  String timezone = await FlutterTimezone.getLocalTimezone();

  // Update the state with the retrieved timezone
  setState(() {
    // Assign the retrieved timezone to the timeZone variable
    timeZone = timezone;
  });

  // Set the local timezone using the tz library
  tz.setLocalLocation(tz.getLocation(timeZone));
}


  showRecommendationNotification() {}

// Define the pickedTime method, which takes a BuildContext parameter
void pickedTime(BuildContext context) async {
  // Initialize variables for hours, minutes, and seconds
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  // Show the time picker dialog and store the selected time in pickedTime
  var pickedTime = await showTimePicker(
    // Pass the context to the time picker
    context: context,
    // Set the initial time to the current time
    initialTime: TimeOfDay.now(),
    // Customize the time picker widget
    builder: (context, childWidget) {
      // For AM/PM format
      return MediaQuery(
        // Modify the media query data for the context
        data: MediaQuery.of(context).copyWith(
          // Use 24-hour format setting
          alwaysUse24HourFormat: false,
          // Adjust text scaling
          textScaler: TextScaler.linear(1.5),
          // Invert colors for the widget
          invertColors: true,
        ),
        // Return the child widget (the time picker)
        child: childWidget!,
      );
    },
    // Set the initial entry mode to input only
    initialEntryMode: TimePickerEntryMode.inputOnly,
  );

  // If a time is selected (pickedTime is not null)
  if (pickedTime != null) {
    // Update the state with the selected time values
    setState(() {
      // Set hours and minutes from the picked time
      hours = pickedTime.hour;
      minutes = pickedTime.minute;
      // Format the selected time as a string
      String freeTime = "$hours : $minutes : 00";
      // Call submitRequest with the necessary parameters
      submitRequest(
        userName,      // User's name
        mobileNumber,  // User's mobile number
        city,          // User's city
        language,      // User's preferred language
        device_id,     // Device ID
        freeTime,      // Formatted free time string
        hours,         // Selected hours
        minutes,       // Selected minutes
        seconds        // Selected seconds (initialized to 0)
      );
    });
  }
}


// Method to submit user data to the server
void submitRequest(
  String userName,           // User's name
  String mobileNumber,       // User's mobile number
  String city,               // User's city
  String language,           // User's preferred language
  String device_id,          // Device ID
  String freeTime,           // User's free time
  int hours,                 // Selected hours
  int minutes,               // Selected minutes
  int seconds                // Selected seconds
) async {
  // Create a map of user data to send to the server
  var UserData = {
    'name': userName,
    'mobile': mobileNumber,
    'city': city,
    'age': "0",
    'gender': "M",
    'language': language,
    'con_time': freeTime,
    'profile_img': "Null",
    'install_flag': "A",
    'device_id': device_id,
    'device_id_count': "0",
    'has_paid': "0"
  };

  // Show a loading alert while the request is being processed
  _ShowLoadingAlert();

  try {
    // Define the API endpoint for inserting user info
    var url = "https://digividya.in/DigiVidyaAPI/api/insertUserInfo";
    // Make a POST request to the API with the user data
    var response = await http.post(Uri.parse(url), body: UserData);

    // Check if the response status is 200 (OK)
    if (response.statusCode == 200) {
      // Parse the JSON response from the server
      Map<String, dynamic> jsonRespons =
        jsonDecode(response.body.toString().replaceAll("\n", " "));

      // If the user registration is successful
      if (jsonRespons['status']) {
        print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% New User Registered %%%%%%%%%%%%%%%%%%%%");
        // Get the application support directory path
        String dirPath = (await getApplicationSupportDirectory()).path;
        // Create a file to store user info
        File jsonFile = File("$dirPath/appInfo.json");

        // If the file does not exist, create it and write user data to it
        if (!await jsonFile.exists()) {
          jsonFile.createSync(recursive: true);
          Map<String, dynamic> userData = {
            'User_Id': jsonRespons['userinfo']['DUI_ID'],
            'UserName': userName,
            'userMobileNo': mobileNumber,
            'userCity': city,
            'userLanguage': language,
            'userDevice_Id': device_id
          };

          jsonFile.writeAsStringSync(jsonEncode(userData));

          print("These are the json data: ${jsonFile.readAsStringSync()}");

          // Create a notification for the user
          notificationService.createNotificationFromJsonData(
            title: "This is your free time.",
            body: "Don't forget to visit DigiVidya.",
            largeIcon: "asset://assets/images/NotificationLargeIcon.webp",
            notificationCategory: NotificationCategory.Recommendation,
            schedule: true,
            hours: hours,
            minutes: minutes,
            seconds: 00,
            isrepeat: true,
            preciseAlarm: true,
            summary: "Daily reminder"
          );

          // Close the loading alert
          Navigator.pop(SubmittingIndecatorContext, false);

          // Navigate to the home page after a short delay
          Future.delayed(Duration(milliseconds: 50), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => homePage(),
              )
            );
          });
        }
      } else {
        // If the user already exists
        print("%%%%%%%%%%%%%%%%%%%%%%% User Already Exist %%%%%%%%%%%%%%%%%%%%%%%%%%");
        if (userName == "Guest") {
          // Get the application support directory path
          String dirPath = (await getApplicationSupportDirectory()).path;
          // Create a file to store user info
          File jsonFile = File("$dirPath/appInfo.json");

          // If the file does not exist, create it and write user data to it
          if (!await jsonFile.exists()) {
            Map<String, dynamic> userData = {
              'User_Id': jsonRespons['user_id'],
              'UserName': userName,
              'userMobileNo': mobileNumber,
              'userCity': city,
              'userLanguage': language,
              'userDevice_Id': device_id
            };

            jsonFile.writeAsStringSync(jsonEncode(userData));

            print("These are the json data: ${jsonFile.readAsStringSync()}");

            // Create a notification for the user
            notificationService.createNotificationFromJsonData(
              title: "This is your free time.",
              body: "Don't forget to visit DigiVidya.",
              largeIcon: "asset://assets/images/NotificationLargeIcon.webp",
              notificationCategory: NotificationCategory.Recommendation,
              schedule: true,
              hours: hours,
              minutes: minutes,
              seconds: 00,
              isrepeat: true,
              preciseAlarm: true,
              summary: "Daily reminder"
            );

            // Close the loading alert
            Navigator.pop(SubmittingIndecatorContext, false);

            // Navigate to the home page after a short delay
            Future.delayed(Duration(milliseconds: 50), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => homePage(),
                )
              );
            });
          }
        } else {
          // Close the loading alert
          Navigator.pop(SubmittingIndecatorContext, false);
          print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Showing Dialog Box for already Registered user %%%%%%%%%%%%%%%%%%%%%%%%%");
          // Show a dialog if the user already exists
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return userAlreadyExist();
            }
          );
        }
      }
    } else {
      // If an internal server error occurred
      Navigator.pop(SubmittingIndecatorContext, false);
      print("%%%%%%%%%%%%%%%%%%%%% Server Status Code : ${response.statusCode} %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
      // Show an error dialog
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          var InternalserverErrorContext = context;
          return InternalserverError(
            InternalserverErrorContext: InternalserverErrorContext,
            ErrorTitle: "Poor Connection",
             Description: "Maybe you have a poor internet connection. Please try again.",
            retryButton: () {
              Future.delayed(
                Duration(milliseconds: 50),
                () {
                  submitRequest(
                    userName, mobileNumber, city, language, device_id, freeTime, hours, minutes, 0
                  );
                },
              );
              Navigator.of(InternalserverErrorContext).pop(false);
            },
            ButtonText: "try again",
          );
        },
      );
    }
  } on http.ClientException catch (e) {
    // Handle client exception errors
    print("Error from Free time : ${e.message}");
    final _checkConnectivity = await _connectivity.checkConnectivity();
    if (_checkConnectivity == ConnectivityResult.none) {
      // If there is no internet connection
      Navigator.pop(SubmittingIndecatorContext, false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          var InternalserverErrorContext = context;
          return InternalserverError(
            InternalserverErrorContext: InternalserverErrorContext,
            ErrorTitle: "No Internet",
             Description: "Maybe you don't have internet. Please check and try again.",
            retryButton: () {
              submitRequest(
                userName, mobileNumber, city, language, device_id, freeTime, hours, minutes, 0
              );
            },
            ButtonText: "reload"
          );
        },
      );
    } else {
      // If there is a poor internet connection
      Navigator.pop(SubmittingIndecatorContext, false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          var InternalserverErrorContext = context;
          return InternalserverError(
            InternalserverErrorContext: InternalserverErrorContext,
            ErrorTitle: "Poor connection",
             Description: "Maybe you have a poor internet connection. Please try again.",
            retryButton: () {
              Future.delayed(
                Duration(milliseconds: 50),
                () {
                  submitRequest(
                    userName, mobileNumber, city, language, device_id, freeTime, hours, minutes, 0
                  );
                },
              );
              Navigator.of(InternalserverErrorContext).pop(false);
            },
            ButtonText: "try again"
          );
        },
      );
    }
  }
}


// Method to show loading alert dialog
void _ShowLoadingAlert() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      // Set the context to the variable for future use
      SubmittingIndecatorContext = context;
      // Return the SubmittingfIndecator widget
      return SubmittingfIndecator();
    },
  );
}

}
