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
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  tz.initializeTimeZones();

  checkPermission();

  runApp(const MyApp());
}

void _deviceOrientation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

void checkPermission() async {
  final AndroidDeviceInfo androidDeviceInfo =
      await DeviceInfoPlugin().androidInfo;
  if (androidDeviceInfo.version.sdkInt < 33) {
    Permission.contacts.request().then((_) {
      print("contact permission given");
      Permission.videos.request().then((_) {
        // print("Video Permission");
        Permission.audio.request().then((_) {
          // print("audio Permission given");
          Permission.scheduleExactAlarm.request().then((_) async {
            // print("schedule Aleram permission given");
            await notificationService.initializedNotification();
          });
        });
      });
    });
  } else {
    Map<Permission, PermissionStatus> status = await [
      Permission.contacts,
      Permission.videos,
      Permission.audio,
      Permission.scheduleExactAlarm,
      // Permission.manageExternalStorage,
    ].request();

    // if(status[Permission.contacts.status] != null){}
    if (await Permission.contacts.isGranted &&
        // await Permission.manageExternalStorage.isGranted &&
        await Permission.videos.isGranted &&
        await Permission.audio.isGranted &&
        await Permission.scheduleExactAlarm.isGranted) {
      await notificationService.initializedNotification();
    } else {}
  }
  return;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, String> phoneContactNumber = {};
  List<String> filteredContactNumber = [];
  List<String> friendsNumberFromServer = [];
  String FormatedDate = "";
  late SharedPreferences _sharedPreferences;
  @override
  void initState() {
    _deviceOrientation();
    disableCapture();
    _featchContact();
    _getMyAppreciationList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF2A61C0),
            onTertiaryContainer: Color.fromARGB(255, 42, 97, 192),
            onTertiary: Color.fromARGB(255, 42, 97, 192),
            // onBackground: Color.fromARGB(255, 42, 97, 192),
            onPrimaryContainer: Color.fromARGB(255, 42, 97, 192)),
        primarySwatch: Colors.blue,
        fontFamily: 'Fontmain',
        useMaterial3: true,
      ),
      home: UpgradeAlert(
          upgrader: Upgrader(durationUntilAlertAgain: Duration(hours: 2)),
          child: Splash(),
          showIgnore: false,
          canDismissDialog: false),
      // home: Splash(),
    );
  }

  void _featchContact() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    if (!_sharedPreferences.containsKey("processedContact")) {
      //In this block we fetch all the contact and fillter and formate in valide phone number
      List<Contact> _allContact = [];

      var status = await Permission.contacts.status;
      // check user granted permission or not ?
      if (status.isGranted) {
        //fetch contact list
        _allContact = await ContactsService.getContacts();

        List<Future<void>> future = []; // this is list of future method
        for (Contact _contact in _allContact) {
          print("Processing Contacts");
          future
              .add(_processContact(_contact)); // This is the future void method
        }

        print("waiting for result");

        await Future.wait(future); // This line perform paraller processing
        print("Contact Processing completd");

        print("Waiting for friends Number from Server");
        //getting friends number from server
        await getFriendsNumberFromServer().then((value) {
          friendsNumberFromServer = value;
        });

        print("friends Number receive");

        if (!_sharedPreferences.containsKey("processedContact") &&
            !_sharedPreferences.containsKey("friendsNumber")) {
                 print("Inserting in Shared Preference");
          _sharedPreferences.setString(
              "processedContact", jsonEncode(phoneContactNumber));
          _sharedPreferences.setStringList(
              "friendsNumber", friendsNumberFromServer);
        } 

        print("Number of Friend got from Server : ${friendsNumberFromServer}");
      } else {}
    } else {
      // In this Block we keep track of new contact number is added in the device
       print("In this Block we keep track of new contact number is added in the device");
      List<Contact> _allContact = [];

      var status = await Permission.contacts.status;
      // check user granted permission or not ?
      if (status.isGranted) {
        //fetch contact list
        _allContact = await ContactsService.getContacts();

        List<Future<void>> future = [];
        for (Contact _contact in _allContact) {
          future.add(_processContact(_contact));
        }

        await Future.wait(future);

        print(
            "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% $filteredContactNumber %%%%%%%%%%%%%%%%%%%%%%");

        //getting friends number from server
        await getFriendsNumberFromServer().then((value) {
          friendsNumberFromServer = value;
        });

        if (_sharedPreferences.getString("processedContact") != null &&
            _sharedPreferences.getStringList("friendsNumber") != null) {
          Map<String, dynamic> oldContact = jsonDecode(
              await _sharedPreferences.getString("processedContact") ?? "{}");

          phoneContactNumber.forEach((key, value) {
            if (!oldContact.containsKey(key)) {
              oldContact[key] = value;
              print(
                  "%%%%%%%%%%%%%%%%%%%%% Contact Update %%%%%%%%%%%%%%%%%%%%%%%");
            }
          });

          _sharedPreferences.setString(
              "processedContact", jsonEncode(oldContact));
        }

        print("Number of Friend got from Server : ${friendsNumberFromServer}");
      } else {}
    }
  }

  Future<void> _processContact(Contact contact) async {
    // Process each phone number of the contact
    for (Item phone in contact.phones!) {
      // Format phone number

      PhoneNumber phoneNumber =
          PhoneNumber.parse(phone.value.toString(), callerCountry: IsoCode.IN);

      String formattedNumber = phoneNumber.international.toString();

      // Remove country code and store 10-digit numbers
      if (formattedNumber.length == 13) {
        formattedNumber = formattedNumber.substring(3); // Remove country code
        if (formattedNumber.length == 10) {
          phoneContactNumber[contact.displayName!] = formattedNumber;
          filteredContactNumber.add(formattedNumber);
        }
      }
    }
  }

  Future<List<String>> getFriendsNumberFromServer() async {
    List<String> friendsNumber = [];
    String dirPath = (await getApplicationSupportDirectory()).path;
    File jsonFile = File("$dirPath/appInfo.json");
    DateTime date = DateTime.now();
    FormatedDate = DateFormat('dd-MM-yyyy').format(date);
    var jsonData = jsonDecode(jsonFile.readAsStringSync());
    // String LocalTestingLink = "http://192.168.1.19/prachi/DigiVidyaAPI/api/updateFriends";
    String getNumber_Url =
        "https://digividya.in/DigiVidyaAPI/api/updateFriends";
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
      var response = await http.post(Uri.parse(getNumber_Url), body: userData);
      if (response.statusCode == 200) {
        print("Connection");
        print("Connection established.....");
        Map<String, dynamic> jsonRespons =
            jsonDecode(response.body.toString().replaceAll("\n", " "));
        if (jsonRespons.isNotEmpty) {
          //Cheak any number add/update in contact list if found add it in list
          for (var number = 0;
              number < jsonRespons['new_friend_list'].length;
              number++) {
            friendsNumber.add(jsonRespons['new_friend_list'][number]);
          }
        }
      } else {
        print("Connection failed ... ${response.statusCode} ");
      }
    } on HttpException catch (e) {
      print("Exception got : ${e.message.toString()}");
    }

    return friendsNumber;
  }

  // Getting User Appreciation List From Server
  void _getMyAppreciationList() async {
    // String LocalTestingLink = "http://192.168.1.19/prachi/DigiVidyaAPI/api/fetchMyAppreciation";
    String getappreciationList_Url =
        "https://digividya.in/DigiVidyaAPI/api/fetchMyAppreciation";
    String dirPath = (await getApplicationSupportDirectory()).path;
    File JsonFile = File("$dirPath/appInfo.json");
    var jsonData = jsonDecode(JsonFile.readAsStringSync());
    String userId = jsonData['User_Id'].toString();
    List<String> AppreciatedBy = [];

    try {
      var userData = {"user_id": userId};

      var response =
          await http.post(Uri.parse(getappreciationList_Url), body: userData);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonRespons =
            jsonDecode(response.body.toString().replaceAll("\n", " "));
        List<dynamic> myAppreciation = jsonRespons['new_friend_list'];

        //Check any one appreciate or not
        if (myAppreciation.isNotEmpty) {
          for (var number = 0; number < myAppreciation.length; number++) {
            AppreciatedBy.add(myAppreciation[number].toString());
          }
          _sharedPreferences = await SharedPreferences.getInstance();
          if (!_sharedPreferences.containsKey("UserAppreciation")) {
            _sharedPreferences.setStringList("UserAppreciation", AppreciatedBy);
          } else {
            if (_sharedPreferences
                .getStringList("UserAppreciation")!
                .isNotEmpty) {
              _sharedPreferences.setStringList(
                  "UserAppreciation", AppreciatedBy);
            } else {}
          }
        } else {
          AppreciatedBy = [];
        }
      }
    } on http.ClientException catch (e) {
      print("Exception got :${e.message.toString()}");
    }

    print("Friends Number who Appreciated You : ${AppreciatedBy}");
  }
}

Future<void> disableCapture() async {
  //disable screenshots and record screen in current screen
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
}
