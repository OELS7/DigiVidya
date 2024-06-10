import 'dart:convert';
import 'dart:io';
import 'package:digividya/screens/Splash.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:digividya/Services/NotificationServices.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:intl/intl.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  // Ensure that widget binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize MobileAds SDK
  MobileAds.instance.initialize();
  // Initialize timezone database
  tz.initializeTimeZones();
  // Check and request necessary permissions
  checkPermission();
  // Run the Flutter application
  runApp(MyApp());
}

void _deviceOrientation() {
  // Set the preferred device orientation to portrait up
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

void checkPermission() async {
  // Get Android device information
  final AndroidDeviceInfo androidDeviceInfo =
      await DeviceInfoPlugin().androidInfo;
  // Check if the Android SDK version is less than 33
  if (androidDeviceInfo.version.sdkInt < 33) {
    // Request contact permission
    Permission.contacts.request().then((_) {
      print("contact permission given");
      // Request video permission after contact permission is granted
      Permission.videos.request().then((_) {
        // print("Video Permission");
        // Request audio permission after video permission is granted
        Permission.audio.request().then((_) {
          // print("audio Permission given");
          // Request exact alarm scheduling permission after audio permission is granted
          Permission.scheduleExactAlarm.request().then((_) async {
            // print("schedule Aleram permission given");
            // Initialize notifications after all permissions are granted
            await notificationService.initializedNotification();
          });
        });
      });
    });
  } else {
    // Request permissions for contacts, videos, audio, and exact alarm scheduling
    Map<Permission, PermissionStatus> status = await [
      Permission.contacts,
      Permission.videos,
      Permission.audio,
      Permission.scheduleExactAlarm,
      // Permission.manageExternalStorage,
    ].request();

    // Check if all permissions are granted
    if (await Permission.contacts.isGranted &&
        // await Permission.manageExternalStorage.isGranted &&
        await Permission.videos.isGranted &&
        await Permission.audio.isGranted &&
        await Permission.scheduleExactAlarm.isGranted) {
      // Initialize notifications if all permissions are granted
      await notificationService.initializedNotification();
    } else {}
  }
  return;
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Define a map to store phone contact numbers with a string key-value pair
  Map<String, String> phoneContactNumber = {};
  // Define a list to store filtered contact numbers
  List<String> filteredContactNumber = [];
  // Define a list to store friends' numbers fetched from the server
  List<String> friendsNumberFromServer = [];
  // Define a string to store a formatted date
  String FormatedDate = "";
  // Declare a late-initialized variable for SharedPreferences
  late SharedPreferences _sharedPreferences;
  @override
  void initState() {
    // Call method to set the preferred device orientation
    _deviceOrientation();
    // Call method to disable screen capture
    disableCapture();
    // Call method to fetch contacts from the device
    _featchContact();
    // Call method to get the list of appreciations
    _getMyAppreciationList();
    // Call the parent class's initState method
    super.initState();
  }

  // Override the build method to describe the part of the UI represented by this widget
  @override
  Widget build(BuildContext context) {
    // Set the system UI mode to immersive sticky, which hides the system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // Return the root of the widget tree, a MaterialApp widget
    return MaterialApp(
      // Disable the debug banner in the top-right corner
      debugShowCheckedModeBanner: false,
      // Define the theme of the application
      theme: ThemeData(
        // Use a color scheme generated from a seed color
        colorScheme: ColorScheme.fromSeed(
            // Set the seed color
            seedColor: Color(0xFF2A61C0),
            // Define colors for tertiary container
            onTertiaryContainer: Color.fromARGB(255, 42, 97, 192),
            // Define colors for tertiary
            onTertiary: Color.fromARGB(255, 42, 97, 192),
            // Define colors for primary container
            onPrimaryContainer: Color.fromARGB(255, 42, 97, 192)),
        // Set the primary swatch color
        primarySwatch: Colors.blue,
        // Set the default font family
        fontFamily: 'Fontmain',
        // Use Material Design 3
        useMaterial3: true,
      ),
      // Set the home screen of the app
      home: UpgradeAlert(
          // Configure the upgrader widget
          upgrader: Upgrader(durationUntilAlertAgain: Duration(minutes: 1)),
          // Set the child widget to display
          child: Splash(),
          // Hide the "Ignore" button in the upgrader dialog
          showIgnore: false,
          // Prevent dismissing the upgrader dialog
          canDismissDialog: false),
      // home: Splash(),
    );
  }

  // Define an asynchronous method to fetch contacts
  void _featchContact() async {
    // Obtain shared preferences instance
    _sharedPreferences = await SharedPreferences.getInstance();

    // Check if the processed contacts key does not exist in shared preferences
    if (!_sharedPreferences.containsKey("processedContact")) {
      // In this block, we fetch all the contacts, filter, and format them into valid phone numbers
      // Initialize an empty list to hold all contacts
      List<Contact> _allContact = [];
      // Check the status of contact permissions
      var status = await Permission.contacts.status;
      // Check if permission is granted
      if (status.isGranted) {
        // Fetch the contact list
        _allContact = await ContactsService.getContacts();

        // Initialize a list of futures for asynchronous processing of contacts
        List<Future<void>> future = [];
        // Iterate through each contact
        for (Contact _contact in _allContact) {
          print("Processing Contacts");
          // Add each contact processing to the list of futures
          future.add(_processContact(_contact));
        }

        print("waiting for result");

        // Wait for all futures to complete
        await Future.wait(future);
        print("Contact Processing completd");

        print("Waiting for friends Number from Server");
        // Get friends' numbers from the server
        await getFriendsNumberFromServer().then((value) {
          friendsNumberFromServer = value;
        });

        print("friends Number receive");
        // Check if the processed contacts and friends' numbers keys do not exist in shared preferences
        if (!_sharedPreferences.containsKey("processedContact") &&
            !_sharedPreferences.containsKey("friendsNumber")) {
          print("Inserting in Shared Preference");
          // Save the processed contacts and friends' numbers to shared preferences
          _sharedPreferences.setString(
              "processedContact", jsonEncode(phoneContactNumber));
          _sharedPreferences.setStringList(
              "friendsNumber", friendsNumberFromServer);
        }

        print("Number of Friend got from Server : ${friendsNumberFromServer}");
      } else {
        // Handle case where permission is not granted (optional)
      }
    } else {
      // In this Block we keep track of new contact number is added in the device
      print(
          "In this Block we keep track of new contact number is added in the device");
      // Initialize an empty list to hold all contacts
      List<Contact> _allContact = [];
      // Check the status of contact permissions
      var status = await Permission.contacts.status;
      // Check if permission is granted
      if (status.isGranted) {
        // Fetch the contact list
        _allContact = await ContactsService.getContacts();
        // Initialize a list of futures for asynchronous processing of contacts
        List<Future<void>> future = [];
        // Iterate through each contact
        for (Contact _contact in _allContact) {
          future.add(_processContact(_contact));
        }
        // Wait for all futures to complete
        await Future.wait(future);

        print(
            "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% $filteredContactNumber %%%%%%%%%%%%%%%%%%%%%%");

        // Get friends' numbers from the server
        await getFriendsNumberFromServer().then((value) {
          friendsNumberFromServer = value;
        });

        // Check if the processed contacts and friends' numbers keys exist in shared preferences
        if (_sharedPreferences.getString("processedContact") != null &&
            _sharedPreferences.getStringList("friendsNumber") != null) {
          // Decode the old contacts from shared preferences
          Map<String, dynamic> oldContact = jsonDecode(
              await _sharedPreferences.getString("processedContact") ?? "{}");

          // Update the old contacts with new ones
          phoneContactNumber.forEach((key, value) {
            if (!oldContact.containsKey(key)) {
              oldContact[key] = value;
              print(
                  "%%%%%%%%%%%%%%%%%%%%% Contact Update %%%%%%%%%%%%%%%%%%%%%%%");
            }
          });

          // Save the updated contacts back to shared preferences
          _sharedPreferences.setString(
              "processedContact", jsonEncode(oldContact));
        }

        print("Number of Friend got from Server : ${friendsNumberFromServer}");
      } else {
        // Handle case where permission is not granted (optional)
      }
    }
  }

  // Define an asynchronous method to process each contact
  Future<void> _processContact(Contact contact) async {
    // Iterate through each phone number of the contac
    for (Item phone in contact.phones!) {
      // Format the phone number using the PhoneNumber package
      PhoneNumber phoneNumber =
          PhoneNumber.parse(phone.value.toString(), callerCountry: IsoCode.IN);

      // Convert the formatted phone number to international format
      String formattedNumber = phoneNumber.international.toString();

      // Remove the country code and store 10-digit numbers
      if (formattedNumber.length == 13) {
        // Remove the country code from the formatted number
        formattedNumber = formattedNumber.substring(3);
        // Check if the number length is 10 digits
        if (formattedNumber.length == 10) {
          // Add the contact's name and formatted number to the phoneContactNumber map
          phoneContactNumber[contact.displayName!] = formattedNumber;
          // Add the formatted number to the filteredContactNumber list
          filteredContactNumber.add(formattedNumber);
        }
      }
    }
  }

  // Define a method to fetch friends' numbers from the server
  Future<List<String>> getFriendsNumberFromServer() async {
    // Initialize an empty list to store friends' numbers
    List<String> friendsNumber = [];
    // Get the path to the application support directory
    String dirPath = (await getApplicationSupportDirectory()).path;
    // Create a File object for the appInfo.json file
    File jsonFile = File("$dirPath/appInfo.json");
    // Get the current date and format it as dd-MM-yyyy
    DateTime date = DateTime.now();
    FormatedDate = DateFormat('dd-MM-yyyy').format(date);

    // Check if the appInfo.json file exists
    if (jsonFile.existsSync()) {
      // Read the contents of the appInfo.json file and decode the JSON data
      var jsonData = jsonDecode(jsonFile.readAsStringSync());
      // String LocalTestingLink = "http://192.168.1.19/prachi/DigiVidyaAPI/api/updateFriends";
      // Define the URL to fetch friends' numbers from the server
      String getNumber_Url =
          "https://digividya.in/DigiVidyaAPI/api/updateFriends";

      // Prepare the request body with user ID, contact list, and app opened date
      var userData = {
        "user_id": jsonData['User_Id'].toString(),
        "contact_list": filteredContactNumber
            .toString()
            .split("[")
            .last
            .split("]")
            .first
            .toString()
            .replaceAll(", ", ","),
        "app_opened_date": FormatedDate
      };

      try {
        // Send a POST request to the server to fetch friends' numbers
        var response =
            await http.post(Uri.parse(getNumber_Url), body: userData);
        // Check if the response status code is 200 (OK)
        if (response.statusCode == 200) {
          print("Connection");
          print("Connection established.....");
          // Decode the JSON response from the server
          Map<String, dynamic> jsonRespons =
              jsonDecode(response.body.toString().replaceAll("\n", " "));
          // Check if the JSON response is not empty
          if (jsonRespons.isNotEmpty) {
            // Iterate over the new_friend_list in the JSON response
            for (var number = 0;
                number < jsonRespons['new_friend_list'].length;
                number++) {
              // Add each friend's number to the friendsNumber list
              friendsNumber.add(jsonRespons['new_friend_list'][number]);
            }
          }
        } else {
          // Print a message if the connection fails
          print("Connection failed ... ${response.statusCode} ");
        }
      } on HttpException catch (e) {
        // Catch and handle HttpException
        print("Exception got : ${e.message.toString()}");
      }
    }
    // Return the list of friends' numbers fetched from the server
    return friendsNumber;
  }

  // Getting User Appreciation List From Server
  void _getMyAppreciationList() async {
     // Define the URL to fetch the appreciation list from the server
    // String LocalTestingLink = "http://192.168.1.19/prachi/DigiVidyaAPI/api/fetchMyAppreciation";
    String getappreciationList_Url =
        "https://digividya.in/DigiVidyaAPI/api/fetchMyAppreciation";
    
    // Get the path to the application support directory
    String dirPath = (await getApplicationSupportDirectory()).path;
    // Create a File object for the appInfo.json file
    File JsonFile = File("$dirPath/appInfo.json");
    // Check if the appInfo.json file exists
    if (JsonFile.existsSync()) {
      // Read the contents of the appInfo.json file and decode the JSON data
      var jsonData = jsonDecode(JsonFile.readAsStringSync());
      // Extract the user ID from the JSON data
      String userId = jsonData['User_Id'].toString();
      // Initialize an empty list to store the IDs of people who appreciated the user
      List<String> AppreciatedBy = [];

      try {
        // Prepare the request body with the user ID
        var userData = {"user_id": userId};
        // Send a POST request to the server to fetch the appreciation list
        var response =
            await http.post(Uri.parse(getappreciationList_Url), body: userData);
        // Check if the response status code is 200 (OK)
        if (response.statusCode == 200) {
          // Decode the JSON response from the server
          Map<String, dynamic> jsonRespons =
              jsonDecode(response.body.toString().replaceAll("\n", " "));
          // Extract the appreciation list from the JSON response
          List<dynamic> myAppreciation = jsonRespons['new_friend_list'];

          // Check if there are any appreciations
          if (myAppreciation.isNotEmpty) {
            // Add each appreciation to the AppreciatedBy list
            for (var number = 0; number < myAppreciation.length; number++) {
              AppreciatedBy.add(myAppreciation[number].toString());
            }
            // Get the SharedPreferences instance
            _sharedPreferences = await SharedPreferences.getInstance();
            // Check if the "UserAppreciation" key exists in SharedPreferences
            if (!_sharedPreferences.containsKey("UserAppreciation")) {
               // If not, store the AppreciatedBy list in SharedPreferences
              _sharedPreferences.setStringList(
                  "UserAppreciation", AppreciatedBy);
            } else {
              // If the key exists and has values, update it with the new list
              if (_sharedPreferences
                  .getStringList("UserAppreciation")!
                  .isNotEmpty) {
                _sharedPreferences.setStringList(
                    "UserAppreciation", AppreciatedBy);
              } else {}
            }
          } else {
            // If no appreciations found, set AppreciatedBy to an empty list
            AppreciatedBy = [];
          }
        }
      } on http.ClientException catch (e) {
        // Catch and handle HTTP Client exceptions
        print("Exception got :${e.message.toString()}");
      }

      print("Friends Number who Appreciated You : ${AppreciatedBy}");
    }
  }
}
// Define an asynchronous function to disable screen capture
Future<void> disableCapture() async {
  // Disable screenshots and screen recording for the current screen
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
}
