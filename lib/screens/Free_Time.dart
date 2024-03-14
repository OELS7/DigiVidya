import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digividya/screens/HomePage.dart';
import 'package:digividya/widgets/InternalServerError.dart';
import 'package:digividya/widgets/userAlredyExist.dart';
import 'package:digividya/widgets/SubmittingIndecator.dart';
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
  String? selectedTime;
  double ScreenHiegth = 0, ScreenWidth = 0;
  String timeZone = "";
  String userName = "";
  String mobileNumber = "";
  String city = "";
  String device_id = "";
  String language = "";
  Connectivity _connectivity = Connectivity();
  var SubmittingIndecatorContext;
  @override
  void initState() {
    super.initState();
    getTimeZone();
  }

  @override
  Widget build(BuildContext context) {
    ScreenHiegth = MediaQuery.of(context).size.height;
    ScreenWidth = MediaQuery.of(context).size.width;
    var arguments = (ModalRoute.of(context)!.settings.arguments ??
        <String, String>{}) as Map;
    userName = arguments['userName'];
    mobileNumber = arguments['mobileNo'];
    city = arguments['city'];
    device_id = arguments['device_id'];
    language = arguments['language'];
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 275,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/Language.webp'),
                        fit: BoxFit.fill)),
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 70, 15, 15),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Choose Your",
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Fontmain',
                              color: Colors.white),
                        ),
                        Text(
                          "Free Time",
                          style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Fontmain',
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              //for timer pop_up
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.627,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.03),
                  child: Column(
                    children: [
                      Center(
                        child: GestureDetector(
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
                                        image: AssetImage(
                                            'assets/images/Button-23-min.webp'),
                                        fit: BoxFit.fill)),
                                child: Center(
                                    child: Text(
                                  'Pick Time',
                                  style: TextStyle(
                                      fontFamily: 'Fontmain',
                                      color: Colors.white,
                                      fontSize: 26),
                                )),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ])),
      ),
    );
  }

  // for takeing time zone of user
  getTimeZone() async {
    String timezone = await FlutterTimezone.getLocalTimezone();
    setState(() {
      timeZone = timezone;
    });
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  showRecommendationNotification() {}

  void pickedTime(BuildContext context) async {
    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    var pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, childWidget) {
        //For AM,PM format
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: false,
                textScaler: TextScaler.linear(1.5),
                invertColors: true),
            child: childWidget!);
      },
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );

    if (pickedTime != null) {
      setState(() {
        hours = pickedTime.hour;
        minutes = pickedTime.minute;
        String freeTime = "$hours : $minutes : 00";
        submitRequest(userName, mobileNumber, city, language, device_id,
            freeTime, hours, minutes, seconds);
      });
    }
  }

  //For if user submit what data of user send to server
  void submitRequest(
      String userName,
      String mobileNumber,
      String city,
      String language,
      String device_id,
      String freeTime,
      int hours,
      int minutes,
      int seconds) async {
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

    _ShowLoadingAlert();

    try {
      //API call for user info insert in Database
      // var url = "http://192.168.1.19/prachi/DigiVidyaAPI/api/insertUserInfo";
      var url = "https://digividya.in/DigiVidyaAPI/api/insertUserInfo";
      var response = await http.post(Uri.parse(url), body: UserData);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonRespons =
            jsonDecode(response.body.toString().replaceAll("\n", " "));

        if (jsonRespons['status']) {
          print(
              "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% New User Registered %%%%%%%%%%%%%%%%%%%%");
          String dirPath = (await getApplicationSupportDirectory()).path;
          File jsonFile = File("$dirPath/appInfo.json");

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

            //for notification data
            notificationService.createNotificationFromJsonData(
                title: "This is your free time.",
                body: "Don't forget to visit DigiVidya.",
                // notificationLayout: NotificationLayout.BigPicture,
                largeIcon: "asset://assets/images/NotificationLargeIcon.webp",
                notificationCategory: NotificationCategory.Recommendation,
                schedule: true,
                hours: hours,
                minutes: minutes,
                seconds: 00,
                isrepeat: true,
                preciseAlarm: true,
                summary: "Daily reminder");

              Navigator.pop(SubmittingIndecatorContext,false);

            Future.delayed(Duration(milliseconds: 50), () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => homePage(),
                  ));
            });
          }
        } else {
          print(
              "%%%%%%%%%%%%%%%%%%%%%%% User Alredy Exist %%%%%%%%%%%%%%%%%%%%%%%%%%");
          if (userName == "Guest") {
            String dirPath = (await getApplicationSupportDirectory()).path;
            File jsonFile = File("$dirPath/appInfo.json");

            if (!await jsonFile.exists()) {
              Map<String, dynamic> userData = {
                //it should be change
                'User_Id': jsonRespons['user_id'],
                'UserName': userName,
                'userMobileNo': mobileNumber,
                'userCity': city,
                'userLanguage': language,
                'userDevice_Id': device_id
              };

              jsonFile.writeAsStringSync(jsonEncode(userData));

              print("These are the json data: ${jsonFile.readAsStringSync()}");

              //for notification data
              notificationService.createNotificationFromJsonData(
                  title: "This is your free time.",
                  body: "Don't forget to visit DigiVidya.",
                  // notificationLayout: NotificationLayout.BigPicture,
                  largeIcon: "asset://assets/images/NotificationLargeIcon.webp",
                  notificationCategory: NotificationCategory.Recommendation,
                  schedule: true,
                  hours: hours,
                  minutes: minutes,
                  seconds: 00,
                  isrepeat: true,
                  preciseAlarm: true,
                  summary: "Daily reminder");

                  Navigator.pop(SubmittingIndecatorContext,false);

              Future.delayed(Duration(milliseconds: 50), () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => homePage(),
                    ));
              });
            }
          } else {
            Navigator.pop(SubmittingIndecatorContext,false);
            print(
                "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Showwing Dialog Box for alredy Register user %%%%%%%%%%%%%%%%%%%%%%%%%");
            //If user alerady exit then show dialog
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return userAlreadyExist();
                });
          }
        }
      } else {
        //If internal server error occured
        Navigator.pop(SubmittingIndecatorContext,false);
        print(
            "%%%%%%%%%%%%%%%%%%%%% Server Status Code : ${response.statusCode} %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
        showDialog(
          context: context,
          builder: (context) {
            var internalServerErrorContext = context;
            return internalServerError(
                internalServerErrorContext: internalServerErrorContext,
                ErrorTitle: "Internal Server error",
                description:
                    "Internal server problem has occurred. Please try again.",
                retryButton: () {
                  Future.delayed(
                    Duration(milliseconds: 50),
                    () {
                      submitRequest(userName, mobileNumber, city, language,
                          device_id, freeTime, hours, minutes, 0);
                    },
                  );
                  Navigator.of(internalServerErrorContext).pop(false);
                },
                ButtonText: "try again");
          },
        );
      }
    } on http.ClientException catch (e) {
      print("Error from Free time : ${e.message}");
      final _checkConnectivity = await _connectivity.checkConnectivity();
      if (_checkConnectivity == ConnectivityResult.none) {
        Navigator.pop(SubmittingIndecatorContext,false);
        showDialog(
          context: context,
          builder: (context) {
            var internalServerErrorContext = context;
            return internalServerError(
                internalServerErrorContext: internalServerErrorContext,
                ErrorTitle: "Internet Error",
                description:
                    "Looks like you might be offline. Please check your internet connection and try again.",
                retryButton: () {
                  submitRequest(userName, mobileNumber, city, language,
                      device_id, freeTime, hours, minutes, 0);
                },
                ButtonText: "reload");
          },
        );
      } else {
        Navigator.pop(SubmittingIndecatorContext,false);
        showDialog(
          context: context,
          builder: (context) {
            var internalServerErrorContext = context;
            return internalServerError(
                internalServerErrorContext: internalServerErrorContext,
                ErrorTitle: "Internal Server error",
                description:
                    "Internal server problem has occurred. Please try again.",
                retryButton: () {
                  Future.delayed(
                    Duration(milliseconds: 50),
                    () {
                      submitRequest(userName, mobileNumber, city, language,
                          device_id, freeTime, hours, minutes, 0);
                    },
                  );
                  Navigator.of(internalServerErrorContext).pop(false);
                },
                ButtonText: "try again");
          },
        );
      }
    }
  }

  void _ShowLoadingAlert() {
    showDialog(
      context: context,
      builder: (context) {
        SubmittingIndecatorContext = context;
        return SubmittingIndecator();
      },
    );
  }
}
